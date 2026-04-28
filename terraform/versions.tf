terraform {
  required_version = ">= 1.5.0"

  required_providers {
    harness = {
      source  = "harness/harness"
      version = "~> 0.42.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}
