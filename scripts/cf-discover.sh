#!/usr/bin/env bash
# Read-only Cloudflare discovery for adopt-in-place. Never prints full API tokens.
set -euo pipefail

ACCOUNT_ID="${CLOUDFLARE_ACCOUNT_ID:-c2dd8a9efc89cbfbee3cd4cc39bf04a4}"
TUNNEL_ID="${CLOUDFLARE_TUNNEL_ID:-90f8797a-8166-4e15-968b-00584ed3c777}"
ZONE_NAME="${CLOUDFLARE_ZONE_NAME:-devkansara.me}"
HOSTNAME="${CLOUDFLARE_HOSTNAME:-photos.devkansara.me}"

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" ]]; then
  echo "CLOUDFLARE_API_TOKEN is not set" >&2
  exit 1
fi

auth=(-H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" -H "Content-Type: application/json")

echo "=== token verify ==="
curl -sS "${auth[@]}" "https://api.cloudflare.com/client/v4/user/tokens/verify" \
| python3 -c 'import sys,json; d=json.load(sys.stdin); r=d.get("result") or {}; print("active:", r.get("status")); print("success:", d.get("success"))'

acct_count=$(curl -sS "${auth[@]}" "https://api.cloudflare.com/client/v4/accounts?per_page=20" \
| python3 -c 'import sys,json; print(len(json.load(sys.stdin).get("result") or []))')
echo "=== accounts visible: ${acct_count} ==="
if [[ "$acct_count" == "0" ]]; then
  echo "WARN: token cannot list accounts — needs Account Settings Read + account include" >&2
fi

echo "=== tunnel ${TUNNEL_ID} ==="
curl -sS "${auth[@]}" "https://api.cloudflare.com/client/v4/accounts/${ACCOUNT_ID}/cfd_tunnel/${TUNNEL_ID}" \
| python3 -c 'import sys,json; d=json.load(sys.stdin); print("success:", d.get("success")); print("errors:", d.get("errors")); r=d.get("result") or {}; print("name:", r.get("name")); print("config_src:", r.get("config_src")); print("status:", r.get("status"))'

echo "=== tunnel config ==="
curl -sS "${auth[@]}" "https://api.cloudflare.com/client/v4/accounts/${ACCOUNT_ID}/cfd_tunnel/${TUNNEL_ID}/configurations" \
| python3 -c 'import sys,json; d=json.load(sys.stdin); print("success:", d.get("success")); print("errors:", d.get("errors")); cfg=(d.get("result") or {}).get("config") or {};
[print("ingress[%d]: hostname=%r service=%r path=%r" % (i, r.get("hostname"), r.get("service"), r.get("path"))) for i,r in enumerate(cfg.get("ingress") or [])]'

echo "=== zone ${ZONE_NAME} ==="
ZONE_JSON=$(curl -sS "${auth[@]}" "https://api.cloudflare.com/client/v4/zones?name=${ZONE_NAME}")
ZONE_ID=$(python3 -c 'import sys,json; r=json.load(sys.stdin).get("result") or []; print(r[0]["id"] if r else "")' <<<"$ZONE_JSON")
if [[ -z "$ZONE_ID" ]]; then
  echo "WARN: zone not visible — token needs Zone Read for ${ZONE_NAME}" >&2
  exit 2
fi
echo "zone_id: ${ZONE_ID}"

echo "=== dns ${HOSTNAME} ==="
curl -sS "${auth[@]}" "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?name=${HOSTNAME}" \
| python3 -c 'import sys,json; d=json.load(sys.stdin); print("success:", d.get("success")); print("errors:", d.get("errors"));
for r in d.get("result") or []: print("id=%s type=%s name=%s content=%s proxied=%s ttl=%s" % (r.get("id"), r.get("type"), r.get("name"), r.get("content"), r.get("proxied"), r.get("ttl")))'
