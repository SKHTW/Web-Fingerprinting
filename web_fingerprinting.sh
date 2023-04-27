#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <target_url>"
    exit 1
fi

TARGET_URL="$1"

echo "Running Web Application Fingerprinting on $TARGET_URL"

# Get HTTP headers
echo "Fetching HTTP headers..."
curl -I -s "$TARGET_URL" > headers.txt
echo "Saved HTTP headers to headers.txt"

# Run WhatWeb for fingerprinting
echo "Running WhatWeb..."
whatweb --color=never --log-xml=fingerprint.xml "$TARGET_URL"
echo "Saved WhatWeb output to fingerprint.xml"

# Download the entire website for offline analysis
echo "Downloading the website for offline analysis..."
wget -q -N -r -l inf --timestamping --no-parent --convert-links --adjust-extension --page-requisites --no-check-certificate -P website-download "$TARGET_URL"
echo "Website downloaded to website-download directory"

# Interactive input for aggressive mode
echo "Do you want to run the aggressive mode? (yes/no)"
read AGGRESSIVE_MODE
if [[ "$AGGRESSIVE_MODE" =~ ^[Yy][Ee][Ss]$ ]]; then
    # Extract domain name for nmap and nikto
    DOMAIN=$(echo "$TARGET_URL" | awk -F[/:] '{print $4}')
    # Run nmap for port scanning and service detection
    echo "Running nmap..."
    nmap -p- -sV -T4 -oN nmap_scan.txt "$DOMAIN"
    echo "Saved nmap output to nmap_scan.txt"

    # Run nikto for vulnerability scanning
    echo "Running nikto..."
    nikto -host "$TARGET_URL" -output nikto_scan.txt
    echo "Saved nikto output to nikto_scan.txt"

# Write a summary file
echo "Writing a summary file..."
{
    echo "Web Application Fingerprinting Results"
    echo "======================================"
    echo "Target URL: $TARGET_URL"
    echo ""
    echo "HTTP Headers: headers.txt"
    echo "WhatWeb Output: fingerprint.xml"
    echo "Downloaded Website: website-download"
    if [[ "$AGGRESSIVE_MODE" =~ ^[Yy][Ee][Ss]$ ]]; then
        echo "Nmap Output: nmap_scan.txt"
        echo "Nikto Output: nikto_scan.txt"
    fi
} > summary.txt

echo "Summary file saved to summary.txt."

fi

echo "Web Application Fingerprinting completed."
