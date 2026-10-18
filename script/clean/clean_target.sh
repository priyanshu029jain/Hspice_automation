#!/bin/bash
# ==============================================================================
# Helper: Clean Specific Raw Output Artifacts (With Confirmation)
# Usage: ./script/clean_target.sh <schematic> <analysis> <param> <corner>
# Example: ./script/clean_target.sh cmos tran vdd ss
# ==============================================================================

SCHEM="$1"
ANALYSIS="$2"
PARAM="$3"
CORNER_RAW="$4"

# Strict safety check: Require all 4 arguments explicitly
if [ -z "$SCHEM" ] || [ -z "$ANALYSIS" ] || [ -z "$PARAM" ] || [ -z "$CORNER_RAW" ]; then
    echo "[!] Error: Target must be fully specified."
    echo "    Usage: ./clean <schematic> <analysis> <param> <corner>"
    echo "    Example: ./clean cmos tran vdd ss"
    exit 1
fi

CORNER=$(echo "$CORNER_RAW" | tr '[:upper:]' '[:lower:]')
TARGET_PATTERN="${SCHEM}_${ANALYSIS}_${PARAM}_${CORNER}"
OUTPUT_DIR="./output"

echo "[*] Target requested: [$TARGET_PATTERN]"

# Check if matching files exist in ./output/
MATCHES=$(ls "$OUTPUT_DIR/${TARGET_PATTERN}"* 2>/dev/null)

if [ -z "$MATCHES" ]; then
    echo "[-] No raw output files found matching target: [$TARGET_PATTERN]"
    exit 0
fi

# Display matched files for user review
echo "[!] The following raw output files will be deleted from $OUTPUT_DIR/:"
echo "$MATCHES" | sed 's/^/    /'
echo "[*] Note: Formatted reports in ./data/ will remain untouched."
echo ""

# Prompt user for confirmation
read -p "Are you sure you want to delete these files? (y/n): " CONFIRM

case "$(echo "$CONFIRM" | tr '[:upper:]' '[:lower:]')" in
    y|yes)
        rm -f "$OUTPUT_DIR/${TARGET_PATTERN}"* 2>/dev/null
        echo "[+] Purged raw outputs for $TARGET_PATTERN in $OUTPUT_DIR/."
        ;;
    *)
        echo "[-] Cleanup canceled by user. No files were deleted."
        exit 0
        ;;
esac