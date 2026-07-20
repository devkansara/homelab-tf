# Docker containers were imported by full container ID (kreuzwerker requires ID, not name).
# Re-import example (if state is empty):
#   terraform import 'module.docker_jellyfin.docker_container.jellyfin' $(ssh root@10.10.0.102 docker inspect -f '{{.Id}}' jellyfin)
#
# Compose YAML lives beside each module + under config/compose/ for recoverability.
