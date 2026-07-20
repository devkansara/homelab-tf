# Adopt-in-place: Immich photos tunnel ingress + DNS (tunnel itself is data-only).
# IDs from cf-discover.sh (2026-07-20).

import {
  to = module.cloudflare.cloudflare_zero_trust_tunnel_cloudflared_config.immich
  id = "c2dd8a9efc89cbfbee3cd4cc39bf04a4/90f8797a-8166-4e15-968b-00584ed3c777"
}

import {
  to = module.cloudflare.cloudflare_record.photos
  id = "c4d64cd4dedd446658389f05db889fd5/745dffc0a768c8a6b9879d974c25ad51"
}
