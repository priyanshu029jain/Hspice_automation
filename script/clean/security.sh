#!/bin/bash
# ==============================================================================
# Central Security Module: Previews files, asks y/n, and checks SHA-256 PIN
# Usage: Called internally by cleanup helper scripts
# Exit Codes: 0 = Authorized, 1 = Canceled or Authentication Failed
# ==============================================================================

# Replace this with your generated SHA-256 PIN hash
PIN_HASH="fe1182e5f93e007f929b7c083fd86447eb2c8950a5827e5e0f0512d4632df945"

FILE_LIST="$1"

if [ -n "$FILE_LIST" ]; then
    echo "[!] The following raw output files will be deleted:"
    echo "$FILE_LIST" | sed 's/^/    /'
    echo "[*] Note: Formatted reports in ./data/ and system log files will remain untouched."
    echo ""
fi

# Step 1: y/n Confirmation
read -p "Are you sure you want to proceed with deletion? (y/n): " CONFIRM

case "$(echo "$CONFIRM" | tr '[:upper:]' '[:lower:]')" in
    y|yes)
        ;;
    *)
        echo "[-] Cleanup canceled by user. No files were deleted."
        exit 1
        ;;
esac

echo ""
echo "[!] SECURITY GATE: Passcode authorization required."

# Step 2: Password Verification
read -s -p "Enter project passcode: " ENTERED_PIN
echo ""

INPUT_HASH=$(echo -n "$ENTERED_PIN" | sha256sum 2>/dev/null | awk '{print $1}')

if [ -z "$INPUT_HASH" ]; then
    INPUT_HASH=$(echo -n "$ENTERED_PIN" | openssl dgst -sha256 | awk '{print $NF}')
fi

if [ -n "$INPUT_HASH" ] && [ "$INPUT_HASH" = "$PIN_HASH" ]; then
    echo "[+] Passcode verified successfully."
    exit 0
else
    echo "[!] ERROR: Incorrect passcode! Operation aborted."
    echo "[-] Security override triggered: No files were deleted."
    exit 1
fi