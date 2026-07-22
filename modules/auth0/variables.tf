variable "api_audience" {
  type        = string
  description = "API identifier / audience (e.g. https://lab.devkansara.me/api)"
}

variable "callbacks" {
  type    = list(string)
  default = ["https://lab.devkansara.me"]
}

variable "logout_urls" {
  type    = list(string)
  default = ["https://lab.devkansara.me"]
}

variable "allowed_origins" {
  type    = list(string)
  default = ["https://lab.devkansara.me"]
}

variable "web_origins" {
  type    = list(string)
  default = ["https://lab.devkansara.me"]
}

variable "enable_google_connection" {
  type        = bool
  description = "Allow Google social login on the Lab Monitor SPA"
  default     = false
}

variable "extra_database_connection_client_ids" {
  type        = list(string)
  description = "Other Auth0 client IDs to keep on Username-Password-Authentication (e.g. M2M app)"
  default     = []
}

variable "auth0_m2m_client_id" {
  type        = string
  description = "Terraform M2M client ID (same as AUTH0_CLIENT_ID in .env)"
  default     = ""
}

data "auth0_client" "default_app" {
  name = "Default App"
}

output "spa_client_id" {
  value = auth0_client.lab_spa.client_id
}

output "api_audience" {
  value = auth0_resource_server.lab_api.identifier
}
