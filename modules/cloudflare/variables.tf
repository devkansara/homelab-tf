variable "account_id" {
  type        = string
  description = "Cloudflare account ID"
}

variable "tunnel_id" {
  type        = string
  description = "Existing cloudflared tunnel UUID (optional; looked up by name if null)"
  default     = null
}

variable "zone_name" {
  type        = string
  description = "DNS zone"
}

variable "tunnel_name" {
  type        = string
  description = "Live tunnel name in Cloudflare Zero Trust"
  default     = "optiplex-immich"
}

variable "ingress" {
  type = list(object({
    hostname = string
    service  = string
  }))
  description = "Hostname → origin mappings (ordered; catch-all 404 appended)"
}
