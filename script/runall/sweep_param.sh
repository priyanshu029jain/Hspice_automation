#!/bin/bash
# ==============================================================================
# Parameter Sweep Engine (PVT / Design Parameter Aware)
# Usage: ./script/runall/sweep_param.sh <schem> <anal> <corner> <p1 p2 ...>
# ==============================================================================

SCHEM="$1"
ANAL="$2"
CORNER="$3"
shift 3
PARAMS=("$@")

if [ -z "$SCHEM" ] || [ -z "$ANAL" ] || [ -z "$CORNER" ] || [ ${#PARAMS[@]} -eq 0 ]; then
    echo "[!] Error: Missing arguments for parameter sweep."
    echo "    Usage: ./runall param <schematic> <analysis> <corner> <param1> <param2> ..."
    exit 1
fi

# Dynamically map analysis types to HSPICE output extension
case "$ANAL" in
    dc|static)    EXT="sw0" ;;
    tran|dynamic) EXT="tr0" ;;
    ac|noise)     EXT="ac0" ;;
    *)            EXT="tr0" ;;
esac

WAVE_FILES=()

echo "[*] Launching Parameter Sweep: Schematic=[$SCHEM] Analysis=[$ANAL] Corner=[$CORNER]..."
echo "======================================================================"

for PARAM in "${PARAMS[@]}"; do
    echo "[>] Executing Parameter: $PARAM"
    ./run "$SCHEM" "$ANAL" "$PARAM" "$CORNER" 1
    if [ $? -ne 0 ]; then
        echo "[!] Sweep aborted due to error in parameter [$PARAM]."
        exit 1
    fi
    WAVE_FILES+=("./output/${SCHEM}_${ANAL}_${PARAM}_${CORNER}.${EXT}")
    echo "----------------------------------------------------------------------"
done

echo "[+] Parameter sweep complete!"
./script/utils/launch_batch_wv.sh "${WAVE_FILES[@]}"