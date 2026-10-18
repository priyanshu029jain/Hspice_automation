#!/bin/bash
SCHEM="$1"
ANAL="$2"
PARAM="$3"
ALL_CORNERS=("tt" "ff" "ss" "sf" "fs")

if [ -z "$SCHEM" ] || [ -z "$ANAL" ] || [ -z "$PARAM" ]; then
    echo "[!] Error: Missing arguments for corner sweep."
    exit 1
fi

# Dynamically map analysis types to HSPICE output extension
case "$ANAL" in
    dc|static)   EXT="sw0" ;;
    tran|dynamic) EXT="tr0" ;;
    ac|noise)    EXT="ac0" ;;
    *)           EXT="tr0" ;;
esac

WAVE_FILES=()

for CORNER in "${ALL_CORNERS[@]}"; do
    echo "[>] Executing Corner: $CORNER"
    ./run "$SCHEM" "$ANAL" "$PARAM" "$CORNER" 1
    if [ $? -ne 0 ]; then
        echo "[!] Sweep aborted due to error in corner [$CORNER]."
        exit 1
    fi
    WAVE_FILES+=("./output/${SCHEM}_${ANAL}_${PARAM}_${CORNER}.${EXT}")
    echo "----------------------------------------------------------------------"
done

echo "[+] Corner sweep complete!"
./script/utils/launch_batch_wv.sh "${WAVE_FILES[@]}"