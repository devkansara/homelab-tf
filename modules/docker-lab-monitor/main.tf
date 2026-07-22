terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
  }
}

# Compose-managed stack lives under /opt/lab-monitor on the guest.
# Terraform tracks identity of the public edge container; full stack via compose.

resource "docker_container" "lab_web" {
  name  = "lab-monitor-web"
  image = var.web_image

  restart  = "unless-stopped"
  must_run = true

  ports {
    internal = 80
    external = var.http_port
  }

  networks_advanced {
    name = var.network_name
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
      log_driver,
      log_opts,
      healthcheck,
      mounts,
      volumes,
    ]
  }
}

resource "docker_container" "lab_api" {
  name  = "lab-monitor-api"
  image = var.api_image

  restart  = "unless-stopped"
  must_run = true

  env = var.api_env

  networks_advanced {
    name = var.network_name
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
      log_driver,
      log_opts,
      healthcheck,
      mounts,
      volumes,
    ]
  }
}

resource "docker_container" "loki" {
  name  = "lab-monitor-loki"
  image = "grafana/loki:3.3.2"

  restart  = "unless-stopped"
  must_run = true

  ports {
    internal = 3100
    external = 3100
  }

  networks_advanced {
    name = var.network_name
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
      log_driver,
      log_opts,
      healthcheck,
      mounts,
      volumes,
    ]
  }
}
