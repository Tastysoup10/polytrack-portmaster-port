#!/bin/bash
# PolyTrack M3 Drive - launcher (r36s-port project, milestone M3b). Started from EmulationStation -> Ports.
#
# Track menu -> race. Controls: A accelerate (the first press starts the timer), B brake/reverse, D-pad or left
# stick steer, X respawn at the last checkpoint, Y restart, Start pause menu (resume, restart, view distance,
# choose track, quit), Start + Select quit.
# Writes only into ./r36s-m3/: records.txt, settings.ini, m3-log-<date>.txt, launcher.log. No network.
#
# PERSONAL TEST ONLY: r36s-m3 contains code generated from PolyTrack's physics module and the game's models and
# tracks (c) Kodub. Do not share this package.

HERE="$(cd "$(dirname "$0")" && pwd)"
PKG="$HERE/r36s-m3"
BIN="$PKG/m3-drive"
LOG="$PKG/launcher.log"

if [ ! -f "$BIN" ] || [ ! -f "$PKG/models/car.glb" ]; then
  echo "PolyTrack M3: folder r36s-m3 is missing or incomplete next to this script." > /dev/tty1 2>/dev/null
  sleep 6
  exit 1
fi
cd "$PKG" || exit 1
RUNLOG="$PKG/m3-log-$(date +%Y%m%d-%H%M%S).txt"
echo "=== launch $(date) as $(id)" >> "$LOG"
trap 'echo "=== launcher received a termination signal" >> "$LOG"' TERM HUP INT

if [ -x "$BIN" ]; then RUN=("$BIN"); else RUN=(/lib/ld-linux-aarch64.so.1 "$BIN"); fi
"${RUN[@]}" --data "$PKG" --log "$RUNLOG" >> "$LOG" 2>&1
echo "=== exit code $? at $(date)" >> "$LOG"
sync
exit 0
