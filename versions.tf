terraform {
  required_version = ">= 1.10"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.111"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.29"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.44"
    }
    auth0 = {
      source  = "auth0/auth0"
      version = "~> 1.14"
    }
  }
}
