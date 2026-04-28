terraform {
  required_providers {
    harness = {
      source  = "harness/harness"
      version = "~> 0.30" # Use the latest stable version
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
  }
}
terraform {
  backend "http" {
    address = "https://app.harness.io/gateway/iacm/api/orgs/playground/projects/jeet_playground/workspaces/GitOps_Agent/terraform-backend?accountIdentifier=gLXLxjTmQhGmdJXhAORKag"
    username = "harness"
    lock_address = "https://app.harness.io/gateway/iacm/api/orgs/playground/projects/jeet_playground/workspaces/GitOps_Agent/terraform-backend/lock?accountIdentifier=gLXLxjTmQhGmdJXhAORKag"
    lock_method = "POST"
    unlock_address = "https://app.harness.io/gateway/iacm/api/orgs/playground/projects/jeet_playground/workspaces/GitOps_Agent/terraform-backend/lock?accountIdentifier=gLXLxjTmQhGmdJXhAORKag"
    unlock_method = "DELETE"
  }
}
