locals {
  hostname_label = replace(var.hostname, ".${var.zone_name}", "")
  tunnel_id      = coalesce(var.tunnel_id, data.cloudflare_zero_trust_tunnel_cloudflared.immich.id)
}

data "cloudflare_zone" "lab" {
  name = var.zone_name
}

# Existing tunnel (connector token stays on Immich VM — not managed here).
data "cloudflare_zero_trust_tunnel_cloudflared" "immich" {
  account_id = var.account_id
  name       = var.tunnel_name
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "immich" {
  account_id = var.account_id
  tunnel_id  = local.tunnel_id

  config {
    ingress_rule {
      hostname = var.hostname
      service  = var.origin_service

      # Match Cloudflare API defaults so adopt-in-place plan stays empty.
      origin_request {
        bastion_mode             = false
        connect_timeout          = "30s"
        disable_chunked_encoding = false
        http2_origin             = false
        keep_alive_connections   = 0
        keep_alive_timeout       = "1m30s"
        no_happy_eyeballs        = false
        no_tls_verify            = false
        proxy_address            = "127.0.0.1"
        proxy_port               = 0
        tcp_keep_alive           = "30s"
        tls_timeout              = "10s"
      }
    }

    ingress_rule {
      service = "http_status:404"
    }
  }
}

resource "cloudflare_record" "photos" {
  zone_id         = data.cloudflare_zone.lab.id
  name            = local.hostname_label
  type            = "CNAME"
  content         = "${local.tunnel_id}.cfargotunnel.com"
  proxied         = true
  ttl             = 1
  allow_overwrite = false
}
