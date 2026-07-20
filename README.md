# Homelab Terraform

Terraform for my Proxmox homelab. The lab was already running (Immich, Jellyfin, *arr*, Tailscale, Cloudflare). This repo imports that state instead of rebuilding everything from a blank OptiPlex and a prayer.

Happy path after `plan`:

```text
No changes. Your infrastructure matches the configuration.
```

That line is weirdly satisfying when Immich is still serving photos and Terraform agrees it should.

> This repo is Terraform only. Secrets, runbooks, and the rest of the lab docs stay private.

## Why

I got tired of tribal knowledge. After a power cut or a late-night "quick fix," I want git + a plan, not "pretty sure the tunnel token is somewhere on the Immich VM."

What this gives me:

- Guests, containers, subnet routes, and public DNS declared in code
- Adopt-in-place imports (track what exists; don't recreate it)
- State in HCP Terraform Cloud, so state isn't marooned on one laptop
- Local execution, because cloud runners can't reach `10.10.0.0/24` no matter how hard you stare at the workspace settings

Pi-hole, the GL.iNet, and Synology stay as runbooks. Not everything needs to be Terraform. Some things just need a checklist and coffee.

## What’s managed

```text
  Internet
      │
      ▼
  Cloudflare  ── ingress + DNS ──►  tunnel ──► Immich :2283
      │
  Tailscale   ── enable 10.10.0.0/24 ─────────────────┐
                                                      │
      ┌───────────────────────────────────────────────▼──┐
      │           OptiPlex · Proxmox (node1)             │
      │                                                  │
      │   LXC 100   tailscale-gateway                    │
      │   VM  101   Immich        (+ Docker)             │
      │   LXC 102   jellyfin      (+ Docker)             │
      │   LXC 103   arr-stack     (+ Docker)             │
      └──────────────────────────────────────────────────┘
```

| Layer | Module | What it does |
|---|---|---|
| Hypervisor | `modules/proxmox` | VM/LXC CPU, RAM, disks, NICs, LXC IPs |
| Apps | `modules/docker-*` | Containers over SSH (Immich / Jellyfin / *arr*) |
| VPN | `modules/tailscale` | Enable the lab subnet route on the gateway |
| Edge | `modules/cloudflare` | Tunnel ingress + DNS for Immich |

Not managed here: guest `/etc/network/interfaces`, the `cloudflared` connector token on disk, DSM clicks, router UCI. If it involves clicking around a web UI at 1am, it's a runbook.

## Adding another service

You don't need the Proxmox UI for a new guest. Add HCL, plan, apply. The rest of the stack stays put.

| Adding | Edit | Skip |
|---|---|---|
| New VM/LXC | `modules/proxmox` | Proxmox UI |
| Docker stack on a guest | `modules/docker-*` + `main.tf` | Hypervisor / Tailscale unless needed |
| Public hostname | `modules/cloudflare` | Guest OS internals |
| Pi / router / NAS | Private runbooks | This repo |

Terraform owns guest shape and (once SSH works) containers. A new QEMU still needs an OS (template or cloud-init) before Docker shows up. LXCs from a template are usually less drama. Existing stuff uses `import`.

Rough steps for something new on the OptiPlex:

1. Guest in `modules/proxmox` (VMID, CPU, RAM, disk, NIC)
2. OS up, SSH on the lab LAN
3. `modules/docker-<name>/` wired in `main.tf`
4. `terraform plan` (only the new bits; Immich should not suddenly want to be replaced)
5. Cloudflare / secrets / DHCP only if you need them

## Design notes

**Adopt-in-place.** The lab existed first. Blowing it away to "do IaC properly" felt like a bad joke. `import` + matching HCL until the plan is empty.

**HCP state, local apply.** State is remote. Plans run on a machine that can see the lab. HCP's runners live in someone else's datacenter; my Proxmox does not.

**Docker `ignore_changes`.** Compose loves changing labels and digests for no useful reason. Without ignores, Terraform keeps "fixing" stacks that were fine yesterday.

**Cloudflare tunnel as a data source.** I tried owning the tunnel resource. One wrong attribute and the plan wanted to recreate it. Lookup by name; manage ingress + DNS. The connector token stays on Immich, where it already works.

**Commit `.terraform.lock.hcl`.** Same provider binaries everywhere. Future-you will thank present-you.

**Secrets stay out of git.** `.env` and `*.tfvars` are gitignored. Examples are committed. Public portfolio and live API keys do not mix.

If `plan` shows `destroy` or `must be replaced`, stop. Homelab Friday can happen any day of the week.

## Quick start

```bash
cp .env.example .env
cp terraform.tfvars.example terraform.tfvars

set -a && source .env && set +a
export TF_TOKEN_app_terraform_io="$TERRAFORM_TOKEN"
export TAILSCALE_API_KEY="${TAILSCALE_TOKEN}"
export CLOUDFLARE_API_TOKEN="${CLOUDFLARE_TOKEN}"

terraform init
terraform plan    # expect: No changes
# terraform apply  # after you actually read the plan
```

Talks to Proxmox (API + some SSH), Docker over SSH, Tailscale API, Cloudflare API.

## Layout

```text
.
├── backend.tf
├── versions.tf
├── main.tf
├── imports*.tf
├── providers*.tf
├── variables.tf
├── modules/
│   ├── proxmox/
│   ├── docker-immich/
│   ├── docker-jellyfin/
│   ├── docker-arr/
│   ├── tailscale/
│   └── cloudflare/
├── .env.example
├── terraform.tfvars.example
└── .terraform.lock.hcl
```

## Status

| Piece | State |
|---|---|
| Proxmox guests 100–103, 101 | Imported, empty plan |
| Docker Immich / Jellyfin / arr | Imported, empty plan |
| Tailscale `10.10.0.0/24` enabled | Imported, empty plan |
| Cloudflare tunnel ingress + DNS | Imported, empty plan |
| HCP workspace | Remote state, local execution |

Uptime graphs live on Uptime Kuma on the Pi. This repo does desired config, not pretty charts.

## Don't

- Don't `terraform destroy` this workspace unless you enjoy rebuilding media stacks for fun
- Don't commit `.env`, `terraform.tfvars`, or `*.tfstate`
- Read every plan for `destroy` / `replace` before `apply`
