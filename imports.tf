# Adopt-in-place complete for Proxmox guests (2026-07-20).
# Kept so a fresh clone with empty state can re-import the same VMIDs.
# After resources are in state, Terraform skips these on subsequent applies.

import {
  to = module.proxmox.proxmox_virtual_environment_container.tailscale
  id = "node1/100"
}

import {
  to = module.proxmox.proxmox_virtual_environment_vm.immich
  id = "node1/101"
}

import {
  to = module.proxmox.proxmox_virtual_environment_container.jellyfin
  id = "node1/102"
}

import {
  to = module.proxmox.proxmox_virtual_environment_container.arr
  id = "node1/103"
}
