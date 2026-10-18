#!/bin/bash
# ==============================================================================
# Multi-Waveform Single Session Launcher (Targeted)
# Usage: ./script/utils/launch_batch_wv.sh <file1> <file2> ...
# ==============================================================================

WV_CMD="wv" # Adjust command if using a wrapper (e.g., wv2018, dsv)

if [ $# -eq 0 ]; then
    echo "[-] No waveform files specified for WaveView."
    exit 0
fi

# Filter arguments to ensure only existing waveform files are loaded
TARGET_FILES=""
for FILE in "$@"; do
    if [ -f "$FILE" ]; then
        TARGET_FILES="$TARGET_FILES $FILE"
    fi
done

if [ -n "$TARGET_FILES" ] && command -v "$WV_CMD" &> /dev/null; then
    echo "[+] Launching WaveView session with current run outputs..."
    $WV_CMD $TARGET_FILES &
fi