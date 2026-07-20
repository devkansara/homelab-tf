# Immich-Server — QEMU VM 101 (adopt-in-place from DISCOVERY.md)
# Guest IP is set inside the OS (no cloud-init). ide2 Debian ISO left unmanaged.

resource "proxmox_virtual_environment_vm" "immich" {
  node_name = var.node_name
  vm_id     = 101
  name      = "Immich-Server"

  on_boot = true
  started = true

  agent {
    enabled = true
  }

  cpu {
    cores = 4
    type  = "host"
  }

  memory {
    dedicated = 8192
    floating  = 0
  }

  scsi_hardware = "virtio-scsi-single"

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 64
    discard      = "on"
    iothread     = true
  }

  network_device {
    bridge      = "vmbr0"
    model       = "virtio"
    mac_address = "BC:24:11:A1:55:3D"
    firewall    = true
  }

  operating_system {
    type = "l26"
  }

  boot_order = ["scsi0", "ide2", "net0"]

  lifecycle {
    ignore_changes = [
      # ide2 Debian ISO present on the VM but not managed as cdrom here
      cdrom,
      disk,
      reboot,
      tablet_device,
      kvm_arguments,
      machine,
      tags,
      description,
    ]
  }
}
