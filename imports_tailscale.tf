# Adopt-in-place: enabled subnet routes on tailscale-gateway.
# Node ID from live `tailscale status --json` (2026-07-20).
# Re-import if state is empty:
#   terraform import 'module.tailscale.tailscale_device_subnet_routes.gateway' nKytmT16v721CNTRL

import {
  to = module.tailscale.tailscale_device_subnet_routes.gateway
  id = "nKytmT16v721CNTRL"
}
