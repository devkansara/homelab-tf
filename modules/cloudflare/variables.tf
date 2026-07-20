variable "account_id" {
  type        = string
  description = "Cloudflare account ID (from Zero Trust / tunnel token payload)"
}

variable "tunnel_id" {
  type        = string
  description = "Existing cloudflared tunnel UUID (optional; looked up by name if null)"
  default     = null
}

variable "zone_name" {
  type        = string
  description = "DNS zone, e.g. devkansara.me"
}

variable "hostname" {
  type        = string
  description = "Public hostname routed to Immich, e.g. photos.devkansara.me"
}

variable "origin_service" {
  type        = string
  description = "Tunnel ingress service URL on the Immich host"
  default     = "http://localhost:2283"
}

variable "tunnel_name" {
  type        = string
  description = "Live tunnel name in Cloudflare Zero Trust"
  default     = "optiplex-immich"
}
