#NOTE: ref https://docs.tilt.dev/api.html
load('ext://namespace', 'namespace_create', 'namespace_inject')
load('ext://helm_remote', 'helm_remote')

# ----------- Settings  ------------

allow_k8s_contexts('kind-kind')
analytics_settings(False)


# ----------- Basics ------------

namespace_create('cert-manager')
#k8s_yaml('values/nginx.yaml')
helm_remote('cert-manager', repo_url='https://charts.jetstack.io', repo_name='jetstack', namespace='cert-manager', set=['installCRDs=true'])


# ----------- ArgoCD ------------
#namespace_create('argocd')

# ---- Argo CD setup

#k8s_yaml(namespace_inject(read_file('infra/argocd/argocd.yaml'), 'argocd'))

# ----------- Images ------------
docker_build('otel-py', 'images/otel-python/')



# ----------- Telemetry ------------
namespace_create('telemetry')

# ---- Grafana Stack setup

#NOTE: see https://grafana.com/docs/loki/latest/installation/helm/
# https://github.com/grafana/helm-charts

helm_remote('loki-stack', repo_url='https://grafana.github.io/helm-charts', repo_name='grafana', namespace='telemetry', set=['fluent-bit.enabled=true,promtail.enabled=false,grafana.enabled=true,grafana.adminPassword=admin,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false'])
helm_remote('tempo', repo_url='https://grafana.github.io/helm-charts', repo_name='tempo', namespace='telemetry', values=['values/tempo.yaml'])
#helm_remote('opentelemetry-collector', repo_url='https://open-telemetry.github.io/opentelemetry-helm-charts', repo_name='open-telemetry', namespace='telemetry', values=['values/opentelemetry-collector.yaml'])
k8s_yaml('values/otel-operator.yaml')
k8s_yaml('values/otel-collector-cr.yaml')


# http://localhost:3000
k8s_resource(workload='loki-stack-grafana', port_forwards='3000:3000')


# ----------- Workflows ------------
namespace_create('workflow')

# ---- Argo Workflow setup

helm_remote('argo-workflows', repo_url='https://argoproj.github.io/argo-helm', repo_name='argo-workflow', namespace='workflow', values=['values/argo-workflow.yaml'])

# https://localhost:2746/workflow
k8s_resource(workload='argo-workflows-server', port_forwards='2746:2746')


# --- WorkflowTemplates

# Note: CRDs don't have pod readines - disable here
k8s_kind('WorkflowTemplate', image_json_path="{..image}", pod_readiness='ignore')
workflow_yamls = listdir('workflows', recursive=True)
for workflow in workflow_yamls:
    k8s_yaml(namespace_inject(workflow, 'workflow'))


# submit workflow with 'argo submit -n workflow --from wftmpl/<name> --log'
