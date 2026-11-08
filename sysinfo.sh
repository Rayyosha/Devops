
#!/usr/bin/env bash
set -euo pipefail

log() {
  echo "$(date '+%F %T') $*"
}

disk_used() {
  df -h / | awk 'NR==2 {print $5}'
}

log "Host: $(hostname)"
log "Disk used on /: $(disk_used)"
log "Logged-in users: $(who | wc -l)"
echo "$MISSING"
