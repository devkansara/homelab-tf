# Tailscale control-plane (API) — not the Proxmox LXC (that is modules/proxmox/ct_tailscale.tf).
# Advertised routes are set on the device (tailscale set --advertise-routes=...).
# This resource only enables routes the device is already advertising.

data "tailscale_device" "gateway" {
  hostname = var.gateway_hostname
}

resource "tailscale_device_subnet_routes" "gateway" {
  device_id = data.tailscale_device.gateway.node_id
  routes    = [var.lab_subnet_cidr]
}
