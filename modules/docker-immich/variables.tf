variable "kiosk_enabled" {
  type        = bool
  description = "Run Immich Kiosk for Portal dashboard slideshow (lab LAN only; not on Cloudflare tunnel)"
  default     = true
}

variable "kiosk_port" {
  type        = number
  description = "Host port for Immich Kiosk (Portal loads http://immich_host:kiosk_port/)"
  default     = 3456
}

variable "kiosk_album_id" {
  type        = string
  description = "Immich album UUID for the slideshow"
  default     = "c60e66de-4527-452a-a642-063543527df1"
}

variable "kiosk_immich_url" {
  type        = string
  description = "Immich API URL as seen from the kiosk container"
  default     = "http://10.10.0.238:2283"
}

variable "kiosk_api_key" {
  type        = string
  description = "Immich API key for the kiosk user (Immich UI; from SOPS/tfvars)"
  sensitive   = true
  default     = ""
}
