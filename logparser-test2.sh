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

# Remove the output file if it exists
if [ -f $2 ]; then
    rm $2
fi

# Print the header to the output file
echo "IP,Date,Method,URL,Protocol,Status" >> $2

# Process the input file
awk -F, 'NR>1 {
    print $1","$2","$3","$4
}' $1 | tr -d '[]' | cut -d ' ' -f1,2,3,5,7,9 | cut -d '?' -f1 | tr ' ' ',' | sed 's/\///' >> $2

# Print the total number of records processed
echo "Total records processed: $(wc -l < $2)-1)"

exit 0
