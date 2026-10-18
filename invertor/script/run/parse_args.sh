#!/bin/bash

# Assign defaults if arguments are missing
SCHEM_NAME="${1:-cmos}"
ANALYSIS_NAME="${2:-dc}"
PARAM_NAME="${3:-none}"
CORNER_NAME="${4:-tt}"

# Convert corner to lowercase for consistent file lookup and naming
CORNER_NAME=$(echo "$CORNER_NAME" | tr '[:upper:]' '[:lower:]')

# Define target paths
SCHEM_FILE="./schematic/${SCHEM_NAME}.sp"
ANALYSIS_FILE="./analysis/${ANALYSIS_NAME}.sp"
PARAM_FILE="./parameter/${PARAM_NAME}.sp"
CORNER_FILE="./corner/${CORNER_NAME}.sp"

# Validate required files
if [ ! -f "$SCHEM_FILE" ]; then 
    echo "[!] Error: Schematic file '$SCHEM_FILE' not found!"
    return 1 2>/dev/null || exit 1
fi

if [ ! -f "$ANALYSIS_FILE" ]; then 
    echo "[!] Error: Analysis file '$ANALYSIS_FILE' not found!"
    return 1 2>/dev/null || exit 1
fi

if [ "$PARAM_NAME" != "none" ] && [ ! -f "$PARAM_FILE" ]; then
    echo "[!] Error: Parameter file '$PARAM_FILE' not found!"
    return 1 2>/dev/null || exit 1
fi

if [ ! -f "$CORNER_FILE" ]; then
    echo "[!] Error: Process Corner file '$CORNER_FILE' not found!"
    return 1 2>/dev/null || exit 1
fi

# Export parsed parameters and paths to caller script environment
export SCHEM_NAME ANALYSIS_NAME PARAM_NAME CORNER_NAME
export SCHEM_FILE ANALYSIS_FILE PARAM_FILE CORNER_FILE

echo "[+] Target Selected: Schematic=[$SCHEM_NAME] Analysis=[$ANALYSIS_NAME] Parameter=[$PARAM_NAME] Corner=[$CORNER_NAME]"