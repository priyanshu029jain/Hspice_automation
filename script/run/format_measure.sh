#!/bin/bash

# Target the generated measure file (.mt0, .ms0, .ma0)
MEAS_RAW=$(ls ${OUT_PREFIX}.m* 2>/dev/null | head -n 1)

if [ -f "$MEAS_RAW" ]; then
    # Construct distinct corner-aware output filename
    TXT_DATA="$DATA_DIR/${RUN_NAME}_measure.txt"
    
    awk '
    BEGIN { header_done=0; num_cols=0 }
    /^\$DATA1/ || /^\.TITLE/ { next }
    
    # 1. Parse Headers (Track column positions)
    !header_done && !/^[[:space:]]*[0-9]/ {
        for (i=1; i<=NF; i++) {
            num_cols++
            all_headers[num_cols] = $i
            
            # Convert header to lowercase for strict exact-match evaluation
            h_clean = tolower($i)
            
            # Exclude exact HSPICE unwanted columns: "index", "alter#", "temper"
            if (h_clean == "index" || h_clean == "alter#" || h_clean == "temper") {
                skip_col[num_cols] = 1
            } else {
                skip_col[num_cols] = 0
            }
        }
        next
    }
    
    # 2. Parse Numerical Data Rows
    /^[[:space:]]*[0-9]/ || header_done {
        header_done=1
        for (i=1; i<=NF; i++) {
            val_cnt++
            all_vals[val_cnt] = $i
        }
    }
    
    END {
        if (num_cols == 0) exit
        
        # Print valid (non-skipped) headers
        for (c=1; c<=num_cols; c++) {
            if (!skip_col[c]) {
                printf "%s\t", all_headers[c]
            }
        }
        print ""
        
        # Print valid data aligned with headers
        for (v=1; v<=val_cnt; v++) {
            col_idx = ((v - 1) % num_cols) + 1
            
            if (!skip_col[col_idx]) {
                printf "%s\t", all_vals[v]
            }
            
            if (col_idx == num_cols) {
                print ""
            }
        }
    }' "$MEAS_RAW" | column -t > "$TXT_DATA"

    echo "[+] Formatted measurement table saved to: $TXT_DATA"
fi