terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
  }
}

resource "docker_container" "radarr" {
  name  = "radarr"
  image = "lscr.io/linuxserver/radarr:latest"

  restart  = "unless-stopped"
  must_run = true

  remove_volumes = false

  env = ["PUID=0", "PGID=0", "TZ=America/Los_Angeles"]

  ports {
    internal = 7878
    external = 7878
  }

  volumes {
    host_path      = "/opt/arr-stack/radarr-config"
    container_path = "/config"
  }

  volumes {
    host_path      = "/data"
    container_path = "/data"
  }

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

resource "docker_container" "sonarr" {
  name  = "sonarr"
  image = "lscr.io/linuxserver/sonarr:latest"

  restart  = "unless-stopped"
  must_run = true

  remove_volumes = false

  env = ["PUID=0", "PGID=0", "TZ=America/Los_Angeles"]

  ports {
    internal = 8989
    external = 8989
  }

  volumes {
    host_path      = "/opt/arr-stack/sonarr-config"
    container_path = "/config"
  }

  volumes {
    host_path      = "/data"
    container_path = "/data"
  }

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

resource "docker_container" "jellyseerr" {
  name  = "jellyseerr"
  image = "fallenbagel/jellyseerr:latest"

  restart  = "unless-stopped"
  must_run = true

  remove_volumes = false

  env = ["LOG_LEVEL=debug", "TZ=America/Los_Angeles"]

  ports {
    internal = 5055
    external = 5055
  }

  volumes {
    host_path      = "/opt/arr-stack/jellyseerr-config"
    container_path = "/app/config"
  }

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

output "container_names" {
  value = [
    docker_container.radarr.name,
    docker_container.sonarr.name,
    docker_container.jellyseerr.name,
  ]
}
