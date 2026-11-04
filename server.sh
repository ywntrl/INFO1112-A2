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
}

handle_assignment() {
#download unit page, turn text to html2text, find assignment row, pull out values and build json 
	number="$1" 
	
	echo "downloading $UNIT_URL" >&2 
	curl -s -f -L "$UNIT_URL" -o "$WORK/unit.html"
		#silent, fail if website returns error, L follows redirect, o saves to a file 
	if [ $? -ne 0 ]; then 
		error "could not download unit page"
		return 
	fi 

	#split each row into own block - html2text mixes table rows together 
	sed 	-e 's#</table>#<hr>#g' \
		# turns end of table into ==== line 		

		-e 's#</*table[^>]*>##g' \
		-e '-e 's#</*thead[^>]*>##g' \
		-e 's#</*tbody[^>]*>##g' \
		#deletes tags to prevent html2text reading as table 

        	-e 's#</tr>##g' \
		-e 's#<tr[^>]*>#<hr>#g' \
		#every row start with ===		

        	-e 's#<t[dh][^>]*>#<p>#g' \
		-e 's#</t[dh]>#</p>#g' \
		#every paragraph = new line 

        	"$WORK/unit.html" > "$WORK/unit_rows.html" 




