#!/bin/bash

RED='\033[0;31m' # To colour error messages
BLUE='\033[0;34m'
NC='\033[0m'
OPTERR="${RED}Invalid option or missing argument error - exiting...${NC}"

# Define a function to parse the input file
parse_input_file() {
    local line=$1
    ip_address=$(echo "$line" | cut -d ',' -f 1)
    date=$(echo "$line" | cut -d ',' -f 2 | cut -d ':' -f 1 | sed 's/\[//')
    method=$(echo "$line" | cut -d ',' -f 3 | cut -d ' ' -f 1)
    url=$(echo "$line" | cut -d ',' -f 3 | cut -d ' ' -f 2 | cut -d '?' -f 1 | sed 's/\///')
    protocol=$(echo "$line" | cut -d ',' -f 3 | cut -d ' ' -f 3)
    status=$(echo "$line" | cut -d ',' -f 4)

    echo "$ip_address,$date,$method,$url,$protocol,$status" >> "$output_file"
}

read -p "Please enter the name of the log file to be processed: " input_file
read -p "Please enter the name you want for the .csv file for the processed results to be placed in: " output_file

if [[ "$input_file" != *.csv ]] || [[ "$output_file" != *.csv ]] || [[ ! -f "$input_file" ]] || [[ ! -s "$input_file" ]]; then

    echo "You need to provide the names of two (2) .csv files"
    echo "  - the name of the log file to be processed and,"
    echo "  - the name you want for the .csv file for the processed results to be placed in, e.g."
    echo "Please try again." 

else
    if [[ -f "$output_file" ]]; then
        rm "$output_file"
    fi

    echo "IP,Date,Method,URL,Protocol,Status" >> "$output_file"
    echo "Processing..."

    sed '1d' "$input_file" | while IFS= read -r line || [[ -n "$line" ]]; do
        parse_input_file "$line"
    done 

    echo "$(($(wc -l < "$output_file") - 1)) records processed..."
fi

exit 0