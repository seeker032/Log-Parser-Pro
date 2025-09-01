#!/bin/bash

# Check if the correct number of arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: ./logparser.sh <input_file> <output_file>"
    exit 1
fi

# Check if the input file exists
if [ ! -f $1 ]; then
    echo "Input file does not exist."
    exit 1
fi

# Remove the output file if it already exists
if [ -f $2 ]; then
    rm $2
fi

# Print the header to the output file
echo "IP,Date,Method,URL,Protocol,Status" >> $2

# Process the input file
awk -F',' 'NR>1 { 
    sub(/\[/,"",$2); 
    split($2,date,":"); 
    split($3,a," "); 
    url_start = index(a[2], "/") + 1;
    url_end = index(a[2], "?") - 1;
    url = substr(a[2], url_start, url_end - url_start + 1);
    print $1","date[1]","a[1]","url","a[3]","$4 
}' $1 >> $2

# Print the total number of records processed
echo "Total records processed: $(wc -l < $2)"