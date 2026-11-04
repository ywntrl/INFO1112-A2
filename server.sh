#!/bin/bash 

PORT=1234 #port nc listens to = Docker start 
RADIUS=500 #metres 

UNIT_URL="https://www.sydney.edu.au/units/INFO1112/2026-S2C-ND-CC"
POP_URL="https://dbr.abs.gov.au/processedData/csv/STE_1.csv"
POI_URL="https://maps.six.nsw.gov.au/arcgis/rest/services/public/NSW_POI/MapServer/0/query"

WORK="$HOME/server_files" #downloads+files sent back 
FIFO="$WORK/reply.fifo" #pipe 


