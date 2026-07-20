# tailscale-gateway — LXC 100
# TUN is currently via legacy lxc.mount.entry / cgroup allow (not device_passthrough).
# Leave that unmanaged so plan stays empty; can migrate to device_passthrough later.

resource "proxmox_virtual_environment_container" "tailscale" {
  node_name = var.node_name
  vm_id     = 100

  unprivileged  = true
  started       = true
  start_on_boot = true

  initialization {
    hostname = "tailscale-gateway"

    ip_config {
      ipv4 {
        address = "10.10.0.143/24"
        gateway = "10.10.0.1"
      }
    }
  }

  cpu {
    cores        = 1
    architecture = "amd64"
  }

  memory {
    dedicated = 512
    swap      = 512
  }

  disk {
    datastore_id = "local-lvm"
    size         = 8
  }

  network_interface {
    name        = "eth0"
    bridge      = "vmbr0"
    firewall    = true
    mac_address = "BC:24:11:2E:D1:3D"
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
    type             = "debian"
  }

  features {
    nesting = true
  }

  console {
    enabled   = true
    type      = "tty"
    tty_count = 2
  }

  lifecycle {
    ignore_changes = [
      operating_system[0].template_file_id,
      description,
      tags,
      device_passthrough,
    ]
  }
}
