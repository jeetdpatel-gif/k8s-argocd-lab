locals {
  proxy_enabled = anytrue([
    var.proxy_http != null,
    var.proxy_https != null,
    var.proxy_username != null,
    var.proxy_password != null
  ])

  raw_agent_manifest = data.harness_platform_gitops_agent_deploy_yaml.byoa.yaml

  tuned_agent_manifest = var.lightweight_local_cluster ? replace(
    replace(
      replace(
        replace(
          replace(
            replace(local.raw_agent_manifest, "cpu: \"2\"", "cpu: \"1\""),
            "memory: 3Gi",
            "memory: 1Gi"
          ),
          "cpu: \"1\"",
          "cpu: \"500m\""
        ),
        "memory: 1Gi",
        "memory: 512Mi"
      ),
      "cpu: 1500m",
      "cpu: 500m"
    ),
    "memory: 3584Mi",
    "memory: 768Mi"
  ) : local.raw_agent_manifest
}

provider "harness" {
  endpoint         = var.harness_platform_url
  account_id       = var.account_id
  platform_api_key = var.harness_platform_api_key
}

provider "kubernetes" {
  config_path    = pathexpand(var.kubeconfig_path)
  config_context = var.kube_context
}

resource "kubernetes_namespace" "gitops" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name   = var.agent_namespace
    labels = var.namespace_labels
  }
}

resource "harness_platform_gitops_agent" "this" {
  identifier  = var.agent_identifier
  name        = var.agent_name
  description = var.agent_description
  org_id      = var.org_id
  project_id  = var.project_id
  operator    = var.gitops_operator
  type        = "CONNECTED_ARGO_PROVIDER"
  tags        = var.tags

  metadata {
    namespace         = var.agent_namespace
    high_availability = var.high_availability
    is_namespaced     = var.namespaced_agent
  }
}

data "harness_platform_gitops_agent_deploy_yaml" "byoa" {
  identifier  = harness_platform_gitops_agent.this.identifier
  account_id  = var.account_id
  org_id      = var.org_id
  project_id  = var.project_id
  namespace   = var.agent_namespace
  skip_crds   = var.skip_crds
  ca_data     = var.ca_data_base64
  private_key = var.private_key_base64

  dynamic "proxy" {
    for_each = local.proxy_enabled ? [1] : []

    content {
      http     = var.proxy_http
      https    = var.proxy_https
      username = var.proxy_username
      password = var.proxy_password
    }
  }
}

resource "local_file" "agent_manifest" {
  content         = local.tuned_agent_manifest
  filename        = "${path.module}/.terraform/harness-gitops-agent-${var.agent_identifier}.yaml"
  file_permission = "0600"

  depends_on = [
    harness_platform_gitops_agent.this
  ]
}

resource "terraform_data" "apply_agent_manifest" {
  triggers_replace = [
    harness_platform_gitops_agent.this.id,
    local_file.agent_manifest.content_sha256,
    var.kube_context,
    var.agent_namespace
  ]

  provisioner "local-exec" {
    command = "kubectl --context='${var.kube_context}' apply -f '${local_file.agent_manifest.filename}'"
  }

  depends_on = [
    local_file.agent_manifest,
    kubernetes_namespace.gitops
  ]
}
