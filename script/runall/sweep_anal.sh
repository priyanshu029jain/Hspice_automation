#!/bin/bash
# ==============================================================================
# Analysis Mode Sweep Engine (Smart Defaults Supported)
# Usage: ./script/runall/sweep_anal.sh <schem> <param> <corner> [a1 a2 ...]
# If no analysis modes are passed, defaults to all 6 modes.
# ==============================================================================

SCHEM="$1"
PARAM="$2"
CORNER="$3"
shift 3
ANALYSES=("$@")

if [ -z "$SCHEM" ] || [ -z "$PARAM" ] || [ -z "$CORNER" ]; then
    echo "[!] Error: Missing required arguments."
    echo "    Usage: ./runall anal <schematic> <parameter> <corner> [analysis1 analysis2 ...]"
    exit 1
fi

# Default to all 6 analysis modes if none are specified by the user
if [ ${#ANALYSES[@]} -eq 0 ]; then
    echo "[*] No analysis modes specified. Defaulting to all 6 modes: (dc tran ac noise dynamic static)"
    ANALYSES=("dc" "tran" "ac" "noise" "dynamic" "static")
fi

WAVE_FILES=()

echo "[*] Launching Analysis Sweep: Schematic=[$SCHEM] Param=[$PARAM] Corner=[$CORNER]..."
echo "======================================================================"

for ANAL in "${ANALYSES[@]}"; do
    echo "[>] Executing Analysis: $ANAL"
    ./run "$SCHEM" "$ANAL" "$PARAM" "$CORNER" 1
    if [ $? -ne 0 ]; then
        echo "[!] Sweep aborted due to error in analysis [$ANAL]."
        exit 1
    fi
    
    # Dynamically determine extension for each analysis
    case "$ANAL" in
        dc|static)    EXT="sw0" ;;
        tran|dynamic) EXT="tr0" ;;
        ac|noise)     EXT="ac0" ;;
        *)            EXT="tr0" ;;
    esac

    WAVE_FILES+=("./output/${SCHEM}_${ANAL}_${PARAM}_${CORNER}.${EXT}")
    echo "----------------------------------------------------------------------"
done

echo "[+] Analysis sweep complete!"
./script/utils/launch_batch_wv.sh "${WAVE_FILES[@]}"