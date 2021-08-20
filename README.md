## Playground

### Getting Started

Installation of necessary libraries:

- [Helm](https://helm.sh/docs/intro/install/)
- [Argo CLI](https://argoproj.github.io/argo-workflows/cli/)
- [ArgoCD CLI](https://argoproj.github.io/argo-cd/cli_installation/)
- [tilt](https://docs.tilt.dev/install.html)
- [ctlptl](https://github.com/tilt-dev/ctlptl#how-do-i-install-it)
- [go-task](https://github.com/go-task/task/blob/master/docs/installation.md#installation)
- [Hashicorp Vault CLI](https://learn.hashicorp.com/tutorials/vault/getting-started-install)


``` sh
./toolchain.sh
```

**Note:**
At this moment only Mac install via [Homebrew](https://brew.sh/) is implemented.

### Starting the cluster

Start a Cluster  with Local Registry:

``` sh
task up 
```

To get the help simply execute `task`. 

`Ctlptl` will make sure to start up a [kind](https://kind.sigs.k8s.io/docs/user/quick-start/) cluster which connected with a local registry.

`Tilt` will startup all components and build necessary Docker Images.

### Components

- Certmanager
- Grafana, Loki, Tempo, Prometheus
- FluentBit
- Open Telemetry Collector
- Argo Workflows
- Hashicorp Vault


#### Hashicorp Vault

| port-forwarded to localhost:9000

To unseal and login download keys then run

```
cat vault.json | jq '.keys_base64[0]' | xargs vault operator unseal
cat vault.json | jq .root_token | xargs vault login
```


