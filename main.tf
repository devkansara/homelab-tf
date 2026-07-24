module "proxmox" {
  source = "./modules/proxmox"

  node_name                 = var.proxmox_node
  lab_ssh_public_key        = trimspace(file(pathexpand(var.lab_ssh_public_key_path)))
  lab_ssh_private_key_path  = var.docker_ssh_private_key_path
  proxmox_host              = "10.10.0.173"
}

module "docker_jellyfin" {
  source = "./modules/docker-jellyfin"
  providers = {
    docker = docker.jellyfin
  }
}

module "docker_arr" {
  source = "./modules/docker-arr"
  providers = {
    docker = docker.arr
  }
}

module "docker_immich" {
  source = "./modules/docker-immich"
  providers = {
    docker = docker.immich
  }

  kiosk_enabled    = var.enable_immich_kiosk
  kiosk_port       = var.immich_kiosk_port
  kiosk_album_id   = var.immich_kiosk_album_id
  kiosk_immich_url = "http://${var.immich_host}:2283"
  kiosk_api_key    = var.immich_kiosk_api_key
}

module "tailscale" {
  source = "./modules/tailscale"
}

module "cloudflare" {
  source = "./modules/cloudflare"

  account_id  = var.cloudflare_account_id
  tunnel_id   = var.cloudflare_tunnel_id
  zone_name   = var.cloudflare_zone_name
  tunnel_name = var.cloudflare_tunnel_name
  ingress = [
    {
      hostname = var.cloudflare_hostname
      service  = var.cloudflare_origin_service
    },
    {
      hostname = var.cloudflare_lab_hostname
      service  = var.cloudflare_lab_origin_service
    },
  ]
}

module "docker_lab_monitor" {
  count  = var.enable_lab_monitor_docker ? 1 : 0
  source = "./modules/docker-lab-monitor"
  providers = {
    docker = docker.lab_monitor
  }
}

module "auth0_lab" {
  count  = var.enable_auth0 ? 1 : 0
  source = "./modules/auth0"

  api_audience    = var.auth0_api_audience
  callbacks       = var.auth0_callbacks
  logout_urls     = var.auth0_logout_urls
  allowed_origins = var.auth0_web_origins
  web_origins     = var.auth0_web_origins

  auth0_m2m_client_id = var.auth0_m2m_client_id
}

output "proxmox_guests" {
  value = module.proxmox.guest_vmids
}

output "docker_containers" {
  value = {
    jellyfin = module.docker_jellyfin.container_name
    arr      = module.docker_arr.container_names
    immich   = module.docker_immich.container_names
  }
}

output "tailscale_gateway" {
  value = {
    node_id        = module.tailscale.gateway_node_id
    tailscale_ips  = module.tailscale.gateway_tailscale_ips
    enabled_routes = module.tailscale.enabled_subnet_routes
  }
}

output "cloudflare_ingress" {
  value = {
    hostnames      = module.cloudflare.hostnames
    tunnel_id      = module.cloudflare.tunnel_id
    zone_id        = module.cloudflare.zone_id
    dns_record_ids = module.cloudflare.dns_record_ids
  }
}

output "lab_monitor" {
  value = {
    vmid           = try(module.proxmox.guest_vmids.lab_monitor, null)
    docker_enabled = var.enable_lab_monitor_docker
    auth0_enabled  = var.enable_auth0
    spa_client_id  = try(module.auth0_lab[0].spa_client_id, null)
    api_audience   = try(module.auth0_lab[0].api_audience, null)
  }
}

output "immich_kiosk" {
  value = {
    enabled  = var.enable_immich_kiosk
    url      = module.docker_immich.kiosk_url
    port     = module.docker_immich.kiosk_port
    album_id = var.immich_kiosk_album_id
  }
}
