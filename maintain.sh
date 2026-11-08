
#!/usr/bin/env bash
# Author: Rayyosha
# maintain.sh - back up a folder, rotate the log,
# keep the newest backups and check services.
# Usage: maintain.sh [source-folder]
set -euo pipefail

SRC="${1:-$HOME/project-data}"
BACKUP_DIR="$HOME/backups"
LOG_DIR="$HOME/logs"
LOG_FILE="$LOG_DIR/maintain.log"
KEEP=5                # backups to keep
MAX_LOG_BYTES=51200   # rotate log above 50 KB
SERVICES=(ssh cron nginx)

mkdir -p "$BACKUP_DIR" "$LOG_DIR"

log() {
  echo "$(date '+%F %T') $*" >> "$LOG_FILE"
}

backup() {
  if [[ ! -d "$SRC" ]]; then
    log "ERROR source $SRC not found"
    return 1
  fi
  local stamp archive
  stamp=$(date +%Y%m%d-%H%M%S)
  archive="$BACKUP_DIR/backup-$stamp.tar.gz"
  if ! tar -czf "$archive" -C "$SRC" .; then
    log "ERROR tar failed for $SRC"
    return 1
  fi
  log "OK backup $archive"
}


prune_backups() {
  local files=("$BACKUP_DIR"/backup-*.tar.gz)
  local total=${#files[@]}
  local i
  for (( i = 0; i < total - KEEP; i++ )); do
    rm -f -- "${files[i]}"
    log "OK removed old backup ${files[i]}"
  done
}


rotate_log() {
  if [[ ! -f "$LOG_FILE" ]]; then
    return 0
  fi
  local size
  size=$(stat -c %s "$LOG_FILE")
  if (( size > MAX_LOG_BYTES )); then
    if [[ -f "$LOG_FILE.2" ]]; then
      mv "$LOG_FILE.2" "$LOG_FILE.3"
    fi
    if [[ -f "$LOG_FILE.1" ]]; then
      mv "$LOG_FILE.1" "$LOG_FILE.2"
    fi
    mv "$LOG_FILE" "$LOG_FILE.1"
  fi
}


check_services() {
  local svc
  local failed=0
  for svc in "${SERVICES[@]}"; do
    if systemctl is-active --quiet "$svc"; then
      log "OK service $svc is running"
    else
      log "FAIL service $svc is not running"
      failed=1
    fi
  done
  return "$failed"
}

load_secret() {
  local f="$HOME/.config/maintain/secret.env"
  if [[ "$(stat -c %a "$f")" != "600" ]]; then
    log "ERROR $f must be mode 600"
    return 1
  fi
  # shellcheck source=/dev/null
  source "$f"
  log "OK token loaded (${#API_TOKEN} chars)"
}

main() {
  local status=0
  rotate_log
  log "START source=$SRC"
  load_secret || status=1
  backup || status=1
  prune_backups
  check_services || status=1
  log "END status=$status"
  return "$status"
}

main
