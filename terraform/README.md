# Harness GitOps BYOA Agent on Minikube or Kubernetes with Terraform

This repository creates a Harness GitOps BYOA agent and installs only the Harness-generated agent manifest into your target Kubernetes cluster by using Terraform.

This setup is intentionally narrow:

- It creates a Harness `CONNECTED_ARGO_PROVIDER` agent.
- It fetches the BYOA operator YAML from Harness.
- It applies that YAML to your cluster.
- It does not install Argo CD.
- It does not install the full managed GitOps stack.

## What Terraform creates

- A `harness_platform_gitops_agent` resource in Harness.
- The BYOA install manifest YAML from Harness using `harness_platform_gitops_agent_operator_yaml`.
- A rendered manifest file written locally by Terraform.
- A Terraform apply step that runs `kubectl apply -f` against that rendered manifest.

## Prerequisites

- A Harness account, API key, and the CD/GitOps module enabled.
- `terraform` installed locally.
- `kubectl` installed and pointing to the cluster you want to use.
- A reachable Kubernetes cluster such as Minikube, EKS, GKE, or AKS.
- Outbound network access from the cluster to Harness and your Git providers.
- An existing Argo CD installation in the target namespace because this is BYOA only.

## Minikube quick start

Start Minikube if it is not already running:

```bash
minikube start --cpus=4 --memory=8192
kubectl config use-context minikube
```

## BYOA flow

In BYOA mode Harness installs only the GitOps agent into the existing Argo CD namespace.

Typical flow:

1. Make sure Argo CD already exists in the target cluster.
2. Set `agent_namespace` to the namespace where Argo CD is running, usually `argocd`.
3. Usually keep `create_namespace = false` because the namespace already exists.
4. Keep `skip_crds = true` to avoid CRD conflicts.

## Configure variables

Copy the example file and update it for your environment:

```bash
cp terraform.tfvars.example terraform.tfvars
```

You can also pass secrets through environment variables instead of storing them in a file:

```bash
export TF_VAR_account_id="your_harness_account_id"
export TF_VAR_harness_platform_api_key="pat.your_api_key"
```

Minimal example:

```hcl
account_id               = "your_harness_account_id"
org_id                   = "default"
project_id               = "your_project_id"
harness_platform_api_key = "pat.your_api_key"
agent_identifier         = "minikube-gitops-agent"
agent_name               = "minikube-gitops-agent"
agent_namespace          = "argocd"
kube_context             = "minikube"
create_namespace         = false
skip_crds                = true
```

## Apply

```bash
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply
```

## Important notes

- If you create the agent at project scope, set both `org_id` and `project_id`.
- If you want to map multiple Argo CD projects in BYOA, Harness recommends creating the agent at account or org scope instead of project scope.
- Do not deploy multiple Harness GitOps agents into the same Argo CD namespace across different Harness scopes or accounts.
- `skip_crds = true` is safer for BYOA because Argo CD CRDs are typically already present.
- The manifest is applied during `terraform apply`, not during `terraform plan`, because Harness returns the final YAML only after the agent exists.

## Files

- [versions.tf](/Users/jeetpatel/Desktop/All/devops/terraform-gitops/versions.tf)
- [variables.tf](/Users/jeetpatel/Desktop/All/devops/terraform-gitops/variables.tf)
- [main.tf](/Users/jeetpatel/Desktop/All/devops/terraform-gitops/main.tf)
- [outputs.tf](/Users/jeetpatel/Desktop/All/devops/terraform-gitops/outputs.tf)
- [terraform.tfvars.example](/Users/jeetpatel/Desktop/All/devops/terraform-gitops/terraform.tfvars.example)
