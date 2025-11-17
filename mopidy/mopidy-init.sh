#!/bin/bash
set -e

LOGDIR="/var/log/mopidy"
LOGFILE="$LOGDIR/mopidy.log"

mkdir -p "$LOGDIR"
touch "$LOGFILE"
chmod 664 "$LOGFILE"

exec mopidy --config /etc/mopidy/mopidy.conf >> "$LOGFILE" 2>&1
