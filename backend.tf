# HCP Terraform Cloud — remote state.
# Workspace execution mode: local (plan/apply on your Mac; state in HCP).
# Proxmox on 10.10.0.0/24 is unreachable from HCP cloud runners.
terraform {
  cloud {
    organization = "RBAC-Horizon"

    workspaces {
      name = "rbac-horizon"
    }
  }
}
