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

output "hostnames" {
  value = [for r in var.ingress : r.hostname]
}

output "dns_record_ids" {
  value = { for k, r in cloudflare_record.ingress : k => r.id }
}
