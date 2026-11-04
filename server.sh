#!/bin/bash 

PORT=1234 #port nc listens to = Docker start 
RADIUS=500 #metres 

UNIT_URL="https://www.sydney.edu.au/units/INFO1112/2026-S2C-ND-CC"
POP_URL="https://dbr.abs.gov.au/processedData/csv/STE_1.csv"
POI_URL="https://maps.six.nsw.gov.au/arcgis/rest/services/public/NSW_POI/MapServer/0/query"

WORK="$HOME/server_files" #downloads+files sent back 
FIFO="$WORK/reply.fifo" #pipe 

error() {
	echo "ERROR: $1" >&2 #print to server terminal
	echo "EROOR: $1" #sent to client 
} 

#missing alpine tools 
install_tools() {
	missing=""
	nc -h 2>$1 | grep -1 OpenBSD || missing="$missing netcat-openbsd" 
	
	which ss > /dev/null 2>&1 || missing="$missing iproute2" 
	which curl > /dev/null 2>&1 || missing="$missing curl" 
	which jq > /dev/null 2>&1 || missing="$missing jq" 
	which html2text > /dev/null 2>&1 || missing="$missing html2text" 
	which python3 > /dev/null 2>&1 || missing="$missing python3" 
	python3 -c "import matplotlib" > /dev/null 2>&1 || missing="$missing python3-matplotlib" 

	if [ -n "$missing" ]; then 
		echo "Installing:$missing"
		apk add $missing > /dev/null 2>&1
		if [$? -ne 0 ]; then 
			echo "could not install:$missing" 
		fi 
	fi 





