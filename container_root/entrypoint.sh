#!/bin/bash
set -e

LOGFILE="/tmp/entrypoint.log"

log() {
    LEVEL=${2:-INFO}
    declare -A LEVELS=(["DEBUG"]=0 ["INFO"]=1 ["ERROR"]=2)
    LEVELNUM=${LEVELS[${LEVEL:-INFO}]}
    USER_LEVELNUM=${LEVELS[${LOG_LEVEL:-INFO}]}
    if [[ "$LEVELNUM" -ge "$USER_LEVELNUM" ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$LEVEL] $1" | tee -a "$LOGFILE"
    fi
}

if [ -f /settings.txt ]; then
    source <(grep -E '^[^#].*=' /settings.txt)
fi
log "Entrypoint starting" INFO

source /opt/ros/humble/setup.bash
log "Sourced /opt/ros/humble/setup.bash" DEBUG
source /sbg_driver_ws/install/setup.bash
log "Sourced /sbg_driver_ws/install/setup.bash" DEBUG

log "Entrypoint ready. Exec: $*" INFO
exec "$@"
