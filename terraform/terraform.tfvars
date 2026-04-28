account_id               = "hGmdJXhAORKag"
org_id                   = "playground"
project_id               = "playground"
harness_platform_api_key = "470b33f0f9bcc0515.Z5hcdzmjsUAhCIiPR7MT"

agent_identifier = "minikube-gitops-agent"
agent_name       = "minikube-gitops-agent"
agent_namespace  = "argocd"
kube_context     = "exam-simulator"
create_namespace = true

high_availability = false
namespaced_agent  = false
skip_crds         = false
gitops_operator   = "ARGO"

tags = {
  environment = "local"
  managed_by  = "terraform"
}
