variable "gateway_hostname" {
  type        = string
  description = "Short hostname of the subnet-router device in the tailnet"
  default     = "tailscale-gateway"
}

variable "lab_subnet_cidr" {
  type        = string
  description = "Lab LAN CIDR advertised and enabled on the gateway"
  default     = "10.10.0.0/24"
}
