# Docker adopt-in-place modules

Tracks **already-running** compose containers via `kreuzwerker/docker` over SSH.

| Module | Host | Containers |
|---|---|---|
| `docker-jellyfin` | `10.10.0.102` | `jellyfin` |
| `docker-arr` | `10.10.0.103` | `radarr`, `sonarr`, `jellyseerr` |
| `docker-immich` | `10.10.0.238` | `immich_*` (4) + optional `immich_kiosk` (:3456) |

Compose YAML is copied into each module (and `config/compose/`) for recoverability. Day-to-day image upgrades can still use `docker compose pull && up` on the guest; TF uses broad `ignore_changes` so compose noise does not force **recreate** (especially Immich DB).

**Secrets:** Immich `DB_PASSWORD` stays in guest `.env` only — not in Terraform. Kiosk `KIOSK_IMMICH_API_KEY` is set via `immich_kiosk_api_key` in tfvars/SOPS (`immich.enc.yaml` → `KIOSK_API_KEY`).

**Kiosk security:** `:3456` is lab-LAN-only (not in Cloudflare tunnel). Album locked server-side (`KIOSK_ALBUMS`, URL queries disabled). Use a dedicated Immich user with a scoped API key (Immich UI).
