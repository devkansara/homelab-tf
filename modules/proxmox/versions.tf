terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.111"
    }
  }
}

variable "node_name" {
  type = string
}

variable "lab_ssh_public_key" {
  type        = string
  description = "OpenSSH public key for new LXC root login (lab_discovery)"
}

variable "lab_ssh_private_key_path" {
  type        = string
  description = "OpenSSH private key for pct feature ops on Proxmox host"
  default     = "~/.ssh/lab_discovery"
}

variable "proxmox_host" {
  type    = string
  default = "10.10.0.173"
}
