#!/bin/bash
# ==============================================================================
# Display Saved Characterization Data (Multi-Corner Aware)
# Usage: ./script/display.sh <schematic> <analysis> <parameter> <corner>
# Example: ./script/display.sh cmos tran vdd ff
# ==============================================================================

SCHEMATIC=${1:-cmos}
ANALYSIS=${2:-tran}
PARAM=${3:-temp}
CORNER=${4:-tt}

# Convert corner to lowercase for consistent file lookup
CORNER_LOWER=$(echo "$CORNER" | tr '[:upper:]' '[:lower:]')

# Target file based on updated naming convention: data/cmos_tran_vdd_ff_measure.txt
TARGET_FILE="./data/${SCHEMATIC}_${ANALYSIS}_${PARAM}_${CORNER_LOWER}_measure.txt"

if [ ! -f "$TARGET_FILE" ]; then
    echo "[-] Error: Result file not found: ${TARGET_FILE}"
    exit 1
fi

echo "========================================================================"
echo "                     HSPICE CHARACTERIZATION REPORT                     "
echo " Target: Schematic=[$SCHEMATIC] | Analysis=[$ANALYSIS] | Param=[$PARAM] "
echo " Corner: ${CORNER_LOWER^^}"
echo " File:   ${TARGET_FILE}"
echo "========================================================================"
echo ""

# Print content directly
cat "$TARGET_FILE"

echo ""
echo "========================================================================"