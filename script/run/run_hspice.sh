#!/bin/bash

OUT_DIR="./output"
DATA_DIR="./data"

mkdir -p "$OUT_DIR" "$DATA_DIR"

# Explicitly include CORNER_NAME in the binary run prefix (converted to lowercase for clean filesystem naming)
CORNER_LOWER=$(echo "${CORNER_NAME}" | tr '[:upper:]' '[:lower:]')
RUN_NAME="${SCHEM_NAME}_${ANALYSIS_NAME}_${PARAM_NAME}_${CORNER_LOWER}"
OUT_PREFIX="$OUT_DIR/$RUN_NAME"

# Clean up stale temporary files for this exact target/corner before simulating
rm -f "${OUT_PREFIX}".*

echo "[+] Simulating: Schematic=[$SCHEM_NAME] Analysis=[$ANALYSIS_NAME] Param=[$PARAM_NAME] Corner=[$CORNER_NAME]..."
hspice top.sp -o "$OUT_PREFIX" > /dev/null

export RUN_NAME OUT_DIR DATA_DIR OUT_PREFIX