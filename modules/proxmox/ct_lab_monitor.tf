# lab-monitor — LXC 240 (observability / lab.devkansara.me origin)

resource "proxmox_virtual_environment_container" "lab_monitor" {
  node_name = var.node_name
  vm_id     = 240

  started       = true
  start_on_boot = true

  initialization {
    hostname = "lab-monitor"

    dns {
      servers = ["10.10.0.250", "1.1.1.1"]
    }

    ip_config {
      ipv4 {
        address = "10.10.0.240/24"
        gateway = "10.10.0.1"
      }
    }
  }

  cpu {
    cores        = 2
    architecture = "amd64"
  }

  memory {
    dedicated = 2048
    swap      = 512
  }

  disk {
    datastore_id = "local-lvm"
    size         = 32
  }

  network_interface {
    name     = "eth0"
    bridge   = "vmbr0"
    firewall = true
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
    type             = "debian"
  }

  # Nesting (for Docker) must be set as root@pam after create if the TF token
  # is not root@pam: pct set 240 -features nesting=1

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
      network_interface[0].mac_address,
      features,
    ]
  }
}
