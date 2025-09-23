#!/bin/bash
set -e

LOGFILE="/tmp/launch_nodes.log"

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

log "Launching nodes (ROS_DOMAIN_ID=$ROS_DOMAIN_ID LOG_LEVEL=$LOG_LEVEL)" INFO
source /opt/ros/humble/setup.bash
source /sbg_driver_pkg_ws/install/setup.bash

log "ros2 launch sbg_driver sbg_device_launch.py" INFO
ros2 launch sbg_driver sbg_device_launch.py & 

log "ros2 launch ntrip_client ntrip_client_launch.py" INFO
ros2 launch ntrip_client ntrip_client_launch.py &

wait
log "All nodes have exited." INFO
