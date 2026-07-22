terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
  }
}

# Immich stack — secrets (DB_PASSWORD) stay in guest .env only; never in TF state via env= here.
# We track container identity + mounts/ports; ignore compose noise + env.

resource "docker_container" "server" {
  name  = "immich_server"
  image = "ghcr.io/immich-app/immich-server:v3"

  restart  = "unless-stopped"
  must_run = true

  remove_volumes = false

  ports {
    internal = 2283
    external = 2283
  }

  volumes {
    host_path      = "/mnt/synology/photos"
    container_path = "/data"
  }

  volumes {
    host_path      = "/etc/localtime"
    container_path = "/etc/localtime"
    read_only      = true
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

resource "docker_container" "machine_learning" {
  name  = "immich_machine_learning"
  image = "ghcr.io/immich-app/immich-machine-learning:v3"

  restart  = "unless-stopped"
  must_run = true

  remove_volumes = false

  volumes {
    volume_name    = "immich_model-cache"
    container_path = "/cache"
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

resource "docker_container" "postgres" {
  name  = "immich_postgres"
  image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0"

  restart  = "unless-stopped"
  must_run = true

  remove_volumes = false

  volumes {
    host_path      = "/home/dev/immich-app/postgres"
    container_path = "/var/lib/postgresql/data"
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

resource "docker_container" "redis" {
  name  = "immich_redis"
  image = "valkey/valkey:9"

  restart  = "unless-stopped"
  must_run = true

  remove_volumes = false

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
    docker_container.server.name,
    docker_container.machine_learning.name,
    docker_container.postgres.name,
    docker_container.redis.name,
  ]
}
