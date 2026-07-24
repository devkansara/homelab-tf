terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
  }
}

locals {
  immich_host_from_url = replace(replace(var.kiosk_immich_url, "http://", ""), ":2283", "")
  kiosk_frame_url      = "http://${local.immich_host_from_url}:${var.kiosk_port}/"
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

# Immich Kiosk slideshow for Portal dashboard. Lab LAN only (:3456). Not on Cloudflare tunnel.
#
# Security (album isolation only):
# - immich_kiosk_api_key: scoped Immich API key for a dedicated read-only user (Immich UI).
#   Share only the target album with that user; key stays server-side in the kiosk container.
# - KIOSK_ALBUMS + DISABLE_URL_QUERIES + DISABLE_CONFIG_ENDPOINT: server-side lock to one album.
# Set immich_kiosk_api_key in tfvars/SOPS after Immich UI provisioning, then re-apply.
resource "docker_container" "kiosk" {
  count = var.kiosk_enabled ? 1 : 0

  name  = "immich_kiosk"
  image = "ghcr.io/damongolding/immich-kiosk:latest"

  restart  = "unless-stopped"
  must_run = true

  remove_volumes = false

  ports {
    internal = 3000
    external = var.kiosk_port
  }

  env = [
    "KIOSK_IMMICH_URL=${var.kiosk_immich_url}",
    "KIOSK_IMMICH_API_KEY=${var.kiosk_api_key}",
    "KIOSK_ALBUMS=${var.kiosk_album_id}",
    "KIOSK_SHOW_TIME=true",
    "KIOSK_SHOW_DATE=true",
    "KIOSK_TIME_FORMAT=24",
    "KIOSK_DURATION=60",
    "KIOSK_TRANSITION=fade",
    "KIOSK_DISABLE_UI=false",
    "KIOSK_DISABLE_URL_QUERIES=true",
    "KIOSK_DISABLE_CONFIG_ENDPOINT=true",
    "KIOSK_ENABLE_URL_BUILDER=false",
    "KIOSK_SHOW_MORE_INFO=false",
    "KIOSK_CACHE=true",
    "KIOSK_PREFETCH=true",
  ]

  lifecycle {
    ignore_changes = [
      image,
      network_mode,
      networks_advanced,
      labels,
      command,
      entrypoint,
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
      volumes,
      devices,
      dns,
      dns_opts,
      dns_search,
      publish_all_ports,
      max_retry_count,
    ]
  }
}

output "container_names" {
  value = concat(
    [
      docker_container.server.name,
      docker_container.machine_learning.name,
      docker_container.postgres.name,
      docker_container.redis.name,
    ],
    var.kiosk_enabled ? [docker_container.kiosk[0].name] : [],
  )
}

output "kiosk_url" {
  value       = var.kiosk_enabled ? local.kiosk_frame_url : null
  description = "Immich Kiosk URL for Portal bridge dashboard (lab LAN only)"
}

output "kiosk_port" {
  value = var.kiosk_enabled ? var.kiosk_port : null
}

