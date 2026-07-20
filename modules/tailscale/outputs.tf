output "gateway_node_id" {
  value       = data.tailscale_device.gateway.node_id
  description = "Stable Tailscale node ID for tailscale-gateway"
}

output "gateway_tailscale_ips" {
  value       = data.tailscale_device.gateway.addresses
  description = "Tailscale IPs assigned to the gateway"
}

output "enabled_subnet_routes" {
  value       = tailscale_device_subnet_routes.gateway.routes
  description = "Subnet routes enabled on the gateway via the admin API"
}
