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
