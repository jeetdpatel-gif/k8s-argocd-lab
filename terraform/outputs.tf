output "gitops_agent_identifier" {
  description = "Harness GitOps agent identifier."
  value       = harness_platform_gitops_agent.this.identifier
}

output "gitops_agent_prefixed_identifier" {
  description = "Prefixed Harness GitOps agent identifier."
  value       = harness_platform_gitops_agent.this.prefixed_identifier
}

output "gitops_agent_token" {
  description = "Harness GitOps agent token."
  value       = harness_platform_gitops_agent.this.agent_token
  sensitive   = true
}

output "gitops_agent_type" {
  description = "Selected agent install mode."
  value       = harness_platform_gitops_agent.this.type
}

output "kubernetes_namespace" {
  description = "Namespace used for the agent install."
  value       = var.agent_namespace
}

output "rendered_manifest_count" {
  description = "The generated Harness agent manifest file path."
  value       = local_file.agent_manifest.filename
}
