variable "proxmox_endpoint" {
  type        = string
  description = "Proxmox API URL, e.g. https://10.10.0.173:8006/"
  default     = "https://10.10.0.173:8006/"
}

variable "proxmox_api_token" {
  type        = string
  description = "API token as user@realm!tokenid=uuid (sensitive)"
  sensitive   = true
}

variable "proxmox_insecure" {
  type        = bool
  description = "Skip TLS verify for self-signed PVE cert"
  default     = true
}

variable "proxmox_ssh_username" {
  type        = string
  description = "SSH user for bind-mount / device ops (usually root)"
  default     = "root"
}

variable "proxmox_ssh_private_key" {
  type        = string
  description = "PEM private key contents for Proxmox SSH (sensitive)"
  sensitive   = true
}

variable "proxmox_node" {
  type        = string
  description = "Proxmox node name"
  default     = "node1"
}

variable "docker_ssh_private_key_path" {
  type        = string
  description = "Path to SSH private key for Docker hosts (jellyfin/arr/immich)"
  default     = "~/.ssh/lab_discovery"
}

variable "jellyfin_host" {
  type    = string
  default = "10.10.0.102"
}

variable "arr_host" {
  type    = string
  default = "10.10.0.103"
}

variable "immich_host" {
  type    = string
  default = "10.10.0.238"
}

variable "immich_db_password" {
  type        = string
  description = "Immich Postgres password (from SOPS; optional until wired)"
  sensitive   = true
  default     = null
}

variable "sonarr_api_key" {
  type      = string
  sensitive = true
  default   = null
}

variable "radarr_api_key" {
  type      = string
  sensitive = true
  default   = null
}

variable "jellyseerr_api_key" {
  type      = string
  sensitive = true
  default   = null
}

variable "tailscale_tailnet" {
  type        = string
  description = "Optional tailnet (legacy email or tailnet ID). Leave null to use the API key's tailnet."
  default     = null
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare account ID"
  default     = "c2dd8a9efc89cbfbee3cd4cc39bf04a4"
}

variable "cloudflare_tunnel_id" {
  type        = string
  description = "Immich cloudflared tunnel UUID"
  default     = "90f8797a-8166-4e15-968b-00584ed3c777"
}

variable "cloudflare_zone_name" {
  type    = string
  default = "devkansara.me"
}

variable "cloudflare_hostname" {
  type    = string
  default = "photos.devkansara.me"
}

variable "cloudflare_tunnel_name" {
  type        = string
  description = "Live tunnel name in Cloudflare"
  default     = "optiplex-immich"
}
