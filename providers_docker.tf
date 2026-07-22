locals {
  docker_ssh_key = pathexpand(var.docker_ssh_private_key_path)
  docker_ssh_opts = [
    "-i", local.docker_ssh_key,
    "-o", "IdentitiesOnly=yes",
    "-o", "StrictHostKeyChecking=accept-new",
  ]
}

# Default docker provider unused (aliases only) — avoid local unix socket.
provider "docker" {
  host                        = "ssh://root@${var.jellyfin_host}:22"
  disable_docker_daemon_check = true
  ssh_opts                    = local.docker_ssh_opts
}

provider "docker" {
  alias    = "jellyfin"
  host     = "ssh://root@${var.jellyfin_host}:22"
  ssh_opts = local.docker_ssh_opts
}

provider "docker" {
  alias    = "arr"
  host     = "ssh://root@${var.arr_host}:22"
  ssh_opts = local.docker_ssh_opts
}

provider "docker" {
  alias    = "immich"
  host     = "ssh://root@${var.immich_host}:22"
  ssh_opts = local.docker_ssh_opts
}

provider "docker" {
  alias    = "lab_monitor"
  host     = "ssh://root@${var.lab_monitor_host}:22"
  ssh_opts = local.docker_ssh_opts
}
