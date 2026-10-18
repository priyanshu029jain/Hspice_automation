#!/bin/bash

# Map active analyses to HSPICE waveform and measurement output extensions
case "$ANALYSIS_NAME" in
    tran|dynamic) 
        WAVE_EXT="tr0"
        MEAS_EXT="mt0"
        ;;
    dc|static)    
        WAVE_EXT="sw0"
        MEAS_EXT="ms0"
        ;;
    ac|noise)     
        WAVE_EXT="ac0"
        MEAS_EXT="ma0"
        ;;
    *)            
        WAVE_EXT="tr0"
        MEAS_EXT="mt0"
        ;;
esac

WAVE_FILE="${OUT_PREFIX}.${WAVE_EXT}"
MEAS_RAW="${OUT_PREFIX}.${MEAS_EXT}"

# Collect existing files to open in WaveView
FILES_TO_OPEN=""

if [ -f "$WAVE_FILE" ]; then
    FILES_TO_OPEN="$WAVE_FILE"
fi

if [ -f "$MEAS_RAW" ]; then
    FILES_TO_OPEN="$FILES_TO_OPEN $MEAS_RAW"
fi

# Launch WaveView with available output files
if [ -n "$FILES_TO_OPEN" ]; then
    echo "[+] Launching WaveView with files: $FILES_TO_OPEN"
    wv $FILES_TO_OPEN &
else
    echo "[!] Simulation failed or no output files found. Check log files in $OUT_DIR"
fi