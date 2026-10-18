#!/bin/bash
# ==============================================================================
# Helper: Secure Purge of All Raw Output Simulation Binaries
# Usage: ./script/clean_all.sh
# ==============================================================================

OUTPUT_DIR="./output"

echo "[*] High-Impact Action: Full Workspace Raw Binary Clean Requested."

# 1. Check if ./output/ contains files
MATCHES=$(ls "$OUTPUT_DIR/"* 2>/dev/null)

if [ -z "$MATCHES" ]; then
    echo "[-] No raw output files found in $OUTPUT_DIR/"
    exit 0
fi

# 2. Hand off preview, y/n confirmation, and SHA-256 PIN check to security.sh
./script/clean/security.sh "$MATCHES" || exit 1

# 3. Execute purge if security verification passes
rm -rf "$OUTPUT_DIR"/* 2>/dev/null
echo "[+] SUCCESS: Purged all raw simulation outputs from $OUTPUT_DIR/."