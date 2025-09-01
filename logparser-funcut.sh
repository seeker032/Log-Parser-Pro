#!/bin/bash

# Function to parse IP
parse_ip() {
    echo $1 | cut -d',' -f1
}

# Function to parse Time
parse_time() {
    echo $1 | cut -d',' -f2 | tr -d '[' | cut -d':' -f1
}

# Function to parse URL
parse_url() {
    echo $1 | cut -d',' -f3 | cut -d' ' -f2 | tr -d '/' | cut -d'?' -f1
}

# Function to parse Method
parse_method() {
    echo $1 | cut -d',' -f3 | cut -d' ' -f1
}

# Function to parse Protocol
parse_protocol() {
    echo $1 | cut -d',' -f3 | cut -d' ' -f3
}

# Function to parse Status
parse_status() {
    echo $1 | cut -d',' -f4
}

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

# Read input file line by line
tail -n +2 "$1" | while IFS= read -r line   # Loops through each line in specified file (using read -r ) and stores them in variable $line. 
                                            # The tail -n +2 "$1" command is used to skip the first line of the input file
do
    # Parse fields using functions
    IP=$(parse_ip "$line")
    Time=$(parse_time "$line")
    URL=$(parse_url "$line")
    Method=$(parse_method "$line")
    Protocol=$(parse_protocol "$line")
    Status=$(parse_status "$line")

    # Write parsed fields to output file
    echo "$IP,$Time,$Method,$URL,$Protocol,$Status" >> $2
done

# Print total number of records processed
echo "Total number of records processed: $(($(wc -l < $2) - 1))"