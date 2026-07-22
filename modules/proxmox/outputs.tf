output "immich_vmid" {
  value = proxmox_virtual_environment_vm.immich.vm_id
}

output "guest_vmids" {
  value = {
    tailscale   = proxmox_virtual_environment_container.tailscale.vm_id
    immich      = proxmox_virtual_environment_vm.immich.vm_id
    jellyfin    = proxmox_virtual_environment_container.jellyfin.vm_id
    arr         = proxmox_virtual_environment_container.arr.vm_id
    lab_monitor = proxmox_virtual_environment_container.lab_monitor.vm_id
  }
}
