output "zone_id" {
  value = data.cloudflare_zone.lab.id
}

output "tunnel_id" {
  value = local.tunnel_id
}

output "tunnel_name" {
  value = data.cloudflare_zero_trust_tunnel_cloudflared.immich.name
}

output "tunnel_status" {
  value = data.cloudflare_zero_trust_tunnel_cloudflared.immich.status
}

output "photos_hostname" {
  value = var.hostname
}

output "dns_record_id" {
  value = cloudflare_record.photos.id
}
