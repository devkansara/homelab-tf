terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
  }
}

# Compose file is tracked in-repo for recoverability; containers are imported adopt-in-place.
resource "docker_container" "jellyfin" {
  name  = "jellyfin"
  image = "lscr.io/linuxserver/jellyfin:latest"

  restart  = "unless-stopped"
  must_run = true

  remove_volumes = false

  env = [
    "PUID=0",
    "PGID=0",
    "TZ=America/Los_Angeles",
  ]

  ports {
    internal = 8096
    external = 8096
  }

  volumes {
    host_path      = "/opt/jellyfin-stack/config"
    container_path = "/config"
  }

  volumes {
    host_path      = "/data/media"
    container_path = "/data/media"
  }

  devices {
    host_path      = "/dev/dri/renderD128"
    container_path = "/dev/dri/renderD128"
    permissions    = "rwm"
  }

  # Compose-created containers drift on labels/networks/image digests — track identity + mounts/ports.
  lifecycle {
    ignore_changes = [
      image,
      network_mode,
      networks_advanced,
      labels,
      command,
      entrypoint,
      env,
      hostname,
      domainname,
      user,
      working_dir,
      log_driver,
      log_opts,
      cpu_shares,
      memory,
      memory_swap,
      shm_size,
      privileged,
      ipc_mode,
      pid_mode,
      cgroupns_mode,
      runtime,
      security_opts,
      sysctls,
      init,
      tty,
      stdin_open,
      gpus,
      healthcheck,
      wait,
      wait_timeout,
      stop_signal,
      stop_timeout,
      container_read_refresh_timeout_milliseconds,
      rm,
      destroy_grace_seconds,
      ports,
      volumes,
      devices,
      dns,
      dns_opts,
      dns_search,
      publish_all_ports,
      max_retry_count,
      restart,
      must_run,
    ]
  }
}

output "container_name" {
  value = docker_container.jellyfin.name
}
