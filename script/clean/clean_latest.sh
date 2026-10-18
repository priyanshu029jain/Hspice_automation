#!/bin/bash
# ==============================================================================
# Helper: Clean Raw Outputs of Most Recent Simulation Run (With Confirmation)
# ==============================================================================

DATA_DIR="./data"
OUTPUT_DIR="./output"

echo "[*] Identifying raw simulation files from the LATEST run..."

# 1. Find the latest run base name from ./data/
LATEST_FILE=$(ls -t "$DATA_DIR"/*_measure.txt 2>/dev/null | head -n 1)

if [ -z "$LATEST_FILE" ]; then
    echo "[-] No previous run reports found in $DATA_DIR"
    exit 0
fi

RUN_BASE=$(basename "$LATEST_FILE" | sed 's/_measure\.txt//')
echo "[+] Latest run identified: $RUN_BASE"

# 2. Check for matching raw simulation files in ./output/
MATCHES=$(ls "$OUTPUT_DIR/${RUN_BASE}"* 2>/dev/null)

if [ -z "$MATCHES" ]; then
    echo "[-] No raw output files found in $OUTPUT_DIR/ matching [$RUN_BASE]"
    exit 0
fi

# 3. Preview files to be deleted
echo "[!] The following raw output files from the latest run will be deleted:"
echo "$MATCHES" | sed 's/^/    /'
echo "[*] Note: Formatted report ($LATEST_FILE) will remain untouched."
echo ""

# 4. Prompt user for confirmation
read -p "Are you sure you want to delete these latest run output files? (y/n): " CONFIRM

case "$(echo "$CONFIRM" | tr '[:upper:]' '[:lower:]')" in
    y|yes)
        rm -f "$OUTPUT_DIR/${RUN_BASE}"* 2>/dev/null
        echo "[+] Purged raw output files in $OUTPUT_DIR/ for $RUN_BASE."
        ;;
    *)
        echo "[-] Cleanup canceled by user. No files were deleted."
        exit 0
        ;;
esac