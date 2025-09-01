#!/bin/bash

# Check if correct number of arguments are passed
if [ $# -ne 2 ]; then
    echo "Usage: ./logparser.sh <input_file> <output_file>"
    exit 1
fi

# Check if input file exists
if [ ! -f $1 ]; then
    echo "Input file does not exist."
    exit 1
fi

# Remove output file if it exists
if [ -f $2 ]; then
    rm $2
fi

# Print header to output file
echo "IP,Date,Method,URL,Protocol,Status" >> $2

# Use awk to parse the input file and write to the output file
awk -F, 'NR>1 {
    split($2, date, ":")
    gsub(/\[/, "", date[1])
    split($3, request, " ")
    gsub(/\//, "", request[2])
    split(request[2], url, "?")
    print $1","date[1]","request[1]","url[1]","request[3]","$4
}' $1 >> $2

# Print total number of records processed
echo "Total number of records processed: $(($(wc -l < $2) - 1))"