# API key: TAILSCALE_TOKEN in terraform/.env (mapped to TAILSCALE_API_KEY when sourcing).
# See config/secrets/README.md.
provider "tailscale" {
  tailnet = var.tailscale_tailnet
}
