# 1. Variables required for Harness and Kubernetes
variable "harness_account_id" { 
  type = string
  default = "gLXLxjTmQhGmdJXhAORKag"
}
variable "harness_org_id" { 
  type = string
  default = "playground"
}
variable "harness_project_id" { 
  type = string 
  default = "jeet_playground"
}
variable "argocd_namespace" { 
  type    = string 
  default = "argocd" # Namespace where your existing ArgoCD lives
}
variable "TF_HTTP_PASSWORD" { 
  type    = string 
  default = pat.gLXLxjTmQhGmdJXhAORKag.69e8d86470b33f0f9bcc0515.Z5hcdzmjsUAhCIiPR7MT" # Namespace where your existing ArgoCD lives
}

# 2. Logically create the GitOps Agent in Harness
resource "harness_platform_gitops_agent" "byoa_agent" {
  identifier = "byoa_poc_agent"
  name       = "BYOA POC Agent"
  account_id = var.harness_account_id
  org_id     = var.harness_org_id
  project_id = var.harness_project_id
  
  # ARGO is the operator type for both managed and BYOA
  operator   = "ARGO"
  type       = "CONNECTED_ARGO_PROVIDER" # Identifies this as BYOA in the UI
}

# 3. Physically install the Agent Helm Chart into the target cluster
resource "helm_release" "harness_gitops_agent" {
  name             = "harness-gitops-agent"
  repository       = "https://harness.github.io/helm-charts"
  chart            = "harness-gitops-agent"
  namespace        = var.argocd_namespace
  create_namespace = false # Assuming the Argo namespace already exists

  # Pass the logically created Agent's metadata
  set {
    name  = "agent.name"
    value = harness_platform_gitops_agent.byoa_agent.name
  }
  set {
    name  = "agent.identifier"
    value = harness_platform_gitops_agent.byoa_agent.identifier
  }
  
  # The dynamically generated token from the resource above
  set_sensitive {
    name  = "agent.token"
    value = harness_platform_gitops_agent.byoa_agent.agent_token
  }
  
  set {
    name  = "harness.accountId"
    value = var.harness_account_id
  }

  # --- CRITICAL BYOA CONFIGURATIONS ---
  # Tell the Helm chart NOT to install its own version of ArgoCD
  set {
    name  = "harness.argocd.create"
    value = "false"
  }
  # Enable BYOA mode on the agent
  set {
    name  = "agent.byoa.enabled"
    value = "true"
  }
}
