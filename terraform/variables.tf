variable "harness_platform_url" {
  description = "Harness Platform gateway URL."
  type        = string
  default     = "https://app.harness.io/gateway"
}

variable "harness_platform_api_key" {
  description = "Harness Platform API key."
  type        = string
  sensitive   = true
}

variable "account_id" {
  description = "Harness account identifier."
  type        = string
}

variable "org_id" {
  description = "Harness organization identifier. Keep null for account-level agent creation."
  type        = string
  default     = null
}

variable "project_id" {
  description = "Harness project identifier. Keep null for account-level or org-level agent creation."
  type        = string
  default     = null
}

variable "agent_identifier" {
  description = "Harness GitOps agent identifier."
  type        = string
}

variable "agent_name" {
  description = "Harness GitOps agent display name."
  type        = string
}

variable "agent_description" {
  description = "Description for the Harness GitOps agent."
  type        = string
  default     = "Harness GitOps agent created with Terraform"
}

variable "agent_namespace" {
  description = "Kubernetes namespace where the agent should be installed."
  type        = string
  default     = "argocd"
}

variable "create_namespace" {
  description = "Create the namespace before applying the agent manifests."
  type        = bool
  default     = false
}

variable "high_availability" {
  description = "Enable HA mode for the Harness GitOps agent."
  type        = bool
  default     = false
}

variable "namespaced_agent" {
  description = "Install a namespaced agent without cluster-scoped permissions."
  type        = bool
  default     = false
}

variable "skip_crds" {
  description = "Skip Argo CD CRD installation in the generated manifests."
  type        = bool
  default     = true
}

variable "gitops_operator" {
  description = "Harness GitOps operator."
  type        = string
  default     = "ARGO"

  validation {
    condition     = contains(["ARGO", "FLAMINGO"], var.gitops_operator)
    error_message = "gitops_operator must be ARGO or FLAMINGO."
  }
}

variable "enable_helm_path_traversal" {
  description = "Unused in BYOA mode. Present only for future expansion."
  type        = bool
  default     = false
}

variable "ca_data_base64" {
  description = "Optional base64-encoded CA chain for agent connectivity."
  type        = string
  default     = null
}

variable "private_key_base64" {
  description = "Optional base64-encoded private key. If provided, Harness does not regenerate the authentication token."
  type        = string
  default     = null
  sensitive   = true
}

variable "proxy_http" {
  description = "Optional HTTP proxy for the agent."
  type        = string
  default     = null
}

variable "proxy_https" {
  description = "Optional HTTPS proxy for the agent."
  type        = string
  default     = null
}

variable "proxy_username" {
  description = "Optional proxy username."
  type        = string
  default     = null
}

variable "proxy_password" {
  description = "Optional proxy password."
  type        = string
  default     = null
  sensitive   = true
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig used for the target cluster."
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Kubeconfig context name. For Minikube this is usually minikube."
  type        = string
  default     = "minikube"
}

variable "namespace_labels" {
  description = "Optional labels for the namespace created by Terraform."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Optional Harness tags for the GitOps agent."
  type        = map(string)
  default     = {}
}

variable "lightweight_local_cluster" {
  description = "Reduce default Harness GitOps resource requests in the rendered manifest for smaller local clusters."
  type        = bool
  default     = true
}
