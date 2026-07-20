# arr-stack — LXC 103 (Sonarr / Radarr / Jellyseerr)

resource "proxmox_virtual_environment_container" "arr" {
  node_name = var.node_name
  vm_id     = 103

  started       = true
  start_on_boot = true

  initialization {
    hostname = "arr-stack"

    dns {
      servers = ["8.8.8.8"]
    }

    ip_config {
      ipv4 {
        address = "10.10.0.103/24"
        gateway = "10.10.0.1"
      }
    }
  }

  cpu {
    cores        = 2
    architecture = "amd64"
  }

  memory {
    dedicated = 1024
    swap      = 512
  }

  disk {
    datastore_id = "local-lvm"
    size         = 8
  }

  mount_point {
    volume = "/mnt/pve/nas-data"
    path   = "/data"
  }

  network_interface {
    name        = "eth0"
    bridge      = "vmbr0"
    firewall    = true
    mac_address = "BC:24:11:F4:26:91"
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
    ]
  }
}
