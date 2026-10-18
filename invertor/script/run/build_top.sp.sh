#!/bin/bash

MEAS_FILE="./measure/${ANALYSIS_NAME}.sp"
TOP_FILE="top.sp"

# 1. Header, Process Corner & Schematic Includes
cat << TOP_EOF > "$TOP_FILE"
* Automated Master Netlist - PVT Corner: ${CORNER_NAME^^}
.option post

* 1. Process Corner Model
.include '$CORNER_FILE'

* 2. Circuit Schematic
.include '$SCHEM_FILE'

TOP_EOF

# 2. Parameter Sweep Data & Analysis Setup
if [ "$PARAM_NAME" = "temp" ]; then
    # Inject direct linear temperature sweep into analysis line
    echo "* Temperature Sweep Analysis" >> "$TOP_FILE"
    sed -E '/^[[:space:]]*\.(tran|dc|ac)/I s/$/ SWEEP temp LIN 5 -40 125/' "$ANALYSIS_FILE" >> "$TOP_FILE"
    
elif [ "$PARAM_NAME" != "none" ] && [ -f "$PARAM_FILE" ]; then
    echo "* Parameter Data Block" >> "$TOP_FILE"
    echo ".include '$PARAM_FILE'" >> "$TOP_FILE"
    echo "" >> "$TOP_FILE"

    # Clean non-breaking spaces (\xC2\xA0 / \xA0) and inject 'SWEEP DATA=param_data'
    tr -d '\r' < "$ANALYSIS_FILE" | LC_ALL=C sed -e 's/[\xA0\xC2]/ /g' | sed -E \
        -e '/^[[:space:]]*\.(tran|dc|ac)/I { /SWEEP/! s/([[:space:]]*\.(tran|dc|ac)[^$\r\n]*)/\1 SWEEP DATA=param_data/I }' >> "$TOP_FILE"
else
    echo "* Default Analysis" >> "$TOP_FILE"
    echo ".include '$ANALYSIS_FILE'" >> "$TOP_FILE"
fi

# 3. Measurement Statements
if [ -f "$MEAS_FILE" ]; then
    echo "" >> "$TOP_FILE"
    echo "* Automated Measurements" >> "$TOP_FILE"
    echo ".include '$MEAS_FILE'" >> "$TOP_FILE"
fi

echo "" >> "$TOP_FILE"
echo ".end" >> "$TOP_FILE"

echo "[+] Master netlist $TOP_FILE generated successfully with Corner=[${CORNER_NAME^^}]."