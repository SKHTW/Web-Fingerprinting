This is a simple bash script to automate web application fingerprinting using popular open-source tools like curl, whatweb, wget, nmap, and nikto. The tool fetches HTTP headers, runs WhatWeb for web application fingerprinting, downloads the entire website for offline analysis, and provides an optional aggressive mode for port scanning and vulnerability scanning.

Why is this tool useful?

Web application fingerprinting is an essential part of the reconnaissance phase in a penetration testing engagement. This tool helps automate the process, saving time and effort. It is particularly useful for:

Identifying web application technologies, versions, and underlying infrastructure.
Gathering information about web servers, plugins, and frameworks.
Downloading the website for offline analysis and further investigation.
Optionally performing port scanning and vulnerability scanning.
Note: Always obtain proper authorization before scanning a website. Scanning and fingerprinting websites without permission is illegal and unethical.


Installation

Follow these steps to set up and use the Web Application Fingerprinting Tool:


Install the necessary tools:


sudo apt-get install curl wget whatweb nmap nikto

Clone the GitHub repository:


git clone https://github.com/SKHTWFT/web-fingerprinting.git

cd web-application-fingerprinting

Make the bash script executable:


chmod +x web_fingerprinting.sh

Usage

Run the script by providing a target URL:

./web_fingerprinting.sh https://example.com

The script will perform the following tasks:

Fetch HTTP headers and save them to headers.txt.

Run WhatWeb for web application fingerprinting and save the output to fingerprint.xml.

Download the entire website for offline analysis in the website-download directory.

After these tasks are completed, the script will prompt you to run the aggressive mode. If you choose to run the aggressive mode, it will perform the following additional tasks:


Run nmap for port scanning and service detection, saving the output to nmap_scan.txt.

Run nikto for vulnerability scanning, saving the output to nikto_scan.txt.


License

This project is licensed under the MIT License.
