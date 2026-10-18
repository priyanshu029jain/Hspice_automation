#!/bin/bash
# ==============================================================================
# Helper: Clean Raw Output Artifacts from Older Simulation Runs
# Usage: Executed via ./clean old [keep_count] from root
# ==============================================================================

# Default to keeping the latest 1 run if no argument is provided
KEEP_COUNT="${1:-1}"
DATA_DIR="./data"
OUTPUT_DIR="./output"

# Validate that keep_count is a positive integer
if ! [[ "$KEEP_COUNT" =~ ^[0-9]+$ ]] || [ "$KEEP_COUNT" -lt 1 ]; then
    echo "[!] Error: Keep count must be a positive integer."
    echo "    Usage: ./clean old [keep_count]"
    exit 1
fi

echo "[*] Identifying older simulation runs (Keeping the latest $KEEP_COUNT run(s))..."

# 1. Fetch all run base names sorted by modification time (newest first)
ALL_RUNS=$(ls -t "$DATA_DIR"/*_measure.txt 2>/dev/null | sed 's/_measure\.txt//' | xargs -n 1 basename)

if [ -z "$ALL_RUNS" ]; then
    echo "[-] No simulation reports found in $DATA_DIR"
    exit 0
fi

TOTAL_RUNS=$(echo "$ALL_RUNS" | wc -l)

if [ "$TOTAL_RUNS" -le "$KEEP_COUNT" ]; then
    echo "[-] Total runs ($TOTAL_RUNS) <= Keep threshold ($KEEP_COUNT). Nothing to clean."
    exit 0
fi

# 2. Extract run base names older than the KEEP_COUNT threshold
OLD_RUNS=$(echo "$ALL_RUNS" | tail -n +$((KEEP_COUNT + 1)))

# 3. Collect matching raw simulation binary files in ./output/
MATCHES=""
for RUN in $OLD_RUNS; do
    FILES=$(ls "$OUTPUT_DIR/${RUN}"* 2>/dev/null)
    if [ -n "$FILES" ]; then
        MATCHES="$MATCHES$FILES"$'\n'
    fi
done

# Remove blank lines
MATCHES=$(echo "$MATCHES" | sed '/^$/d')

if [ -z "$MATCHES" ]; then
    echo "[-] No raw output binaries found in $OUTPUT_DIR/ for older runs."
    exit 0
fi

# 4. Hand off preview, y/n confirmation, and SHA-256 PIN check to security module
./script/clean/security.sh "$MATCHES" || exit 1

# 5. Execute deletion if security verification passes
echo "$MATCHES" | xargs rm -f 2>/dev/null
echo "[+] Successfully purged raw outputs for older runs in $OUTPUT_DIR/."