#!/bin/bash
# ==============================================================================
# Schematic Sweep Engine
# Usage: ./script/runall/sweep_schem.sh <anal> <param> <corner> <s1 s2 ...>
# ==============================================================================

ANAL="$1"
PARAM="$2"
CORNER="$3"
shift 3
SCHEMS=("$@")

if [ -z "$ANAL" ] || [ -z "$PARAM" ] || [ -z "$CORNER" ] || [ ${#SCHEMS[@]} -eq 0 ]; then
    echo "[!] Error: Missing arguments for schematic sweep."
    echo "    Usage: ./runall schem <analysis> <parameter> <corner> <schem1> <schem2> ..."
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

echo "[*] Launching Schematic Sweep: Analysis=[$ANAL] Param=[$PARAM] Corner=[$CORNER]..."
echo "======================================================================"

for SCHEM in "${SCHEMS[@]}"; do
    echo "[>] Executing Schematic: $SCHEM"
    ./run "$SCHEM" "$ANAL" "$PARAM" "$CORNER" 1
    if [ $? -ne 0 ]; then
        echo "[!] Sweep aborted due to error in schematic [$SCHEM]."
        exit 1
    fi
    WAVE_FILES+=("./output/${SCHEM}_${ANAL}_${PARAM}_${CORNER}.${EXT}")
    echo "----------------------------------------------------------------------"
done

echo "[+] Schematic sweep complete!"
./script/utils/launch_batch_wv.sh "${WAVE_FILES[@]}"