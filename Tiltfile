#NOTE: ref https://docs.tilt.dev/api.html
load('ext://namespace', 'namespace_create', 'namespace_inject')
load('ext://helm_remote', 'helm_remote')

# ----------- Ingress ------------

k8s_yaml('values/nginx.yaml')

# ----------- ArgoCD ------------
#namespace_create('argocd')

# ---- Argo CD setup

#k8s_yaml(namespace_inject(read_file('infra/argocd/argocd.yaml'), 'argocd'))


# ----------- Telemetry ------------
namespace_create('telemetry')

# ---- Grafana Stack setup

#NOTE: see https://grafana.com/docs/loki/latest/installation/helm/
# https://github.com/grafana/helm-charts

helm_remote('loki-stack', repo_url='https://grafana.github.io/helm-charts', repo_name='grafana', namespace='telemetry', set=['fluent-bit.enabled=true,promtail.enabled=false,grafana.enabled=true,grafana.adminPassword=admin,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false'])
helm_remote('tempo', repo_url='https://grafana.github.io/helm-charts', repo_name='tempo', namespace='telemetry')

# http://localhost:3000
k8s_resource(workload='loki-stack-grafana', port_forwards='3000:3000')


# ----------- Workflows ------------
namespace_create('workflow')

# ---- Argo Workflow setup

helm_remote('argo-workflows', repo_url='https://argoproj.github.io/argo-helm', repo_name='argo-workflow', namespace='workflow', values=['values/argo-workflow.yaml'])

# https://localhost:2746/workflow
k8s_resource(workload='argo-workflows-server', port_forwards='2746:2746')


# --- WorkflowTemplates

workflow_yamls = listdir('workflows', recursive=True)
for workflow in workflow_yamls:
    k8s_yaml(namespace_inject(workflow, 'workflow'))

# submit workflow with 'argo submit -n workflow --from wftmpl/<name> --log'