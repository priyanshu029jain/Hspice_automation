#!/bin/bash
# ==============================================================================
# Smart HSPICE Log & Diagnostics Parser
# Usage: ./script/utils/error_parser.sh [optional_log_file]
# ==============================================================================

OUT_DIR="./output"

# 1. Target log selection (passed argument or most recently modified .lis file)
LOG_FILE="$1"
if [ -z "$LOG_FILE" ]; then
    LOG_FILE=$(ls -t "$OUT_DIR"/*.lis 2>/dev/null | head -n 1)
fi

if [ -z "$LOG_FILE" ] || [ ! -f "$LOG_FILE" ]; then
    echo "[-] No simulation log (.lis) files found in $OUT_DIR/."
    exit 0
fi

echo "======================================================================"
echo "                 HSPICE SIMULATION ERROR DIAGNOSTICS                  "
echo " Target Log: $LOG_FILE"
echo "======================================================================"

# 2. Extract lines containing fatal HSPICE error signatures
ERRORS=$(grep -i -E "\*\*error\*\*|fatal|abort|unresolved|failed" "$LOG_FILE" | grep -v "0 errors")

if [ -z "$ERRORS" ]; then
    echo "[+] SUCCESS: No syntax or fatal errors detected in log."
    echo "[*] If outputs look abnormal, check DC convergence or model parameters."
else
    echo "[!] CRITICAL ERRORS DETECTED:"
    echo ""
    echo "$ERRORS" | sed 's/^/    /'
    echo ""
fi