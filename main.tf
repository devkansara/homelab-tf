module "proxmox" {
  source = "./modules/proxmox"

  node_name = var.proxmox_node
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
}

module "tailscale" {
  source = "./modules/tailscale"
}

module "cloudflare" {
  source = "./modules/cloudflare"

  account_id  = var.cloudflare_account_id
  tunnel_id   = var.cloudflare_tunnel_id
  zone_name   = var.cloudflare_zone_name
  hostname    = var.cloudflare_hostname
  tunnel_name = var.cloudflare_tunnel_name
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
    node_id           = module.tailscale.gateway_node_id
    tailscale_ips     = module.tailscale.gateway_tailscale_ips
    enabled_routes    = module.tailscale.enabled_subnet_routes
  }
}

output "cloudflare_photos" {
  value = {
    hostname   = module.cloudflare.photos_hostname
    tunnel_id  = module.cloudflare.tunnel_id
    zone_id    = module.cloudflare.zone_id
    dns_record = module.cloudflare.dns_record_id
  }
}
