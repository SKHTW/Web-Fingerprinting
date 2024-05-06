#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <target_url>"
    exit 1
fi

TARGET_URL="$1"
OUTPUT_DIR=$(mktemp -d "fingerprint-$(date +%Y%m%d%H%M%S)-XXX")
echo "Results will be saved in $OUTPUT_DIR"

echo "Running Web Application Fingerprinting on $TARGET_URL"

# Function to fetch HTTP headers
fetch_http_headers() {
    echo "Fetching HTTP headers..."
    if curl -I -s "$TARGET_URL" > "$OUTPUT_DIR/headers.txt"; then
        echo "Saved HTTP headers to $OUTPUT_DIR/headers.txt"
    else
        echo "Failed to fetch HTTP headers."
    fi
}

# Function to run WhatWeb
run_whatweb() {
    echo "Running WhatWeb..."
    if whatweb --color=never --log-xml="$OUTPUT_DIR/fingerprint.xml" "$TARGET_URL"; then
        echo "Saved WhatWeb output to $OUTPUT_DIR/fingerprint.xml"
    else
        echo "WhatWeb failed to run."
    fi
}

# Function to download the website
download_website() {
    echo "Downloading the website for offline analysis..."
    if wget -q -N -r -l inf --timestamping --no-parent --convert-links --adjust-extension --page-requisites --no-check-certificate -P "$OUTPUT_DIR/website-download" "$TARGET_URL"; then
        echo "Website downloaded to $OUTPUT_DIR/website-download directory"
    else
        echo "Failed to download the website."
    fi
}

fetch_http_headers
run_whatweb
download_website

# Interactive input for aggressive mode
echo "Do you want to run the aggressive mode? (yes/no)"
read AGGRESSIVE_MODE
if [[ "$AGGRESSIVE_MODE" =~ ^[Yy][Ee][Ss]$ ]]; then
    DOMAIN=$(echo "$TARGET_URL" | awk -F[/:] '{print $4}')
    echo "Running nmap..."
    if nmap -p- -sV -T4 -oN "$OUTPUT_DIR/nmap_scan.txt" "$DOMAIN"; then
        echo "Saved nmap output to $OUTPUT_DIR/nmap_scan.txt"
    else
        echo "Nmap scan failed."
    fi
    echo "Running nikto..."
    if nikto -host "$TARGET_URL" -output "$OUTPUT_DIR/nikto_scan.txt"; then
        echo "Saved nikto output to $OUTPUT_DIR/nikto_scan.txt"
    else
        echo "Nikto scan failed."
    fi
fi

echo "Web Application Fingerprinting completed."
