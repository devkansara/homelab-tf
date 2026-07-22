variable "web_image" {
  type    = string
  default = "lab-monitor-web:local"
}

variable "api_image" {
  type    = string
  default = "lab-monitor-api:local"
}

variable "http_port" {
  type    = number
  default = 3080
}

variable "network_name" {
  type    = string
  default = "lab-monitor_default"
}

variable "api_env" {
  type    = list(string)
  default = []
}

output "container_names" {
  value = {
    web  = docker_container.lab_web.name
    api  = docker_container.lab_api.name
    loki = docker_container.loki.name
  }
}
