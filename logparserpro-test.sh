#!/bin/bash

RED='\033[0;31m' # To colour error messages
BLUE='\033[0;34m'
NC='\033[0m'
OPTERR="${RED}Invalid option or missing argument error - exiting...${NC}"
s_option=false
d_option=false
z_option=false

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

# Parses command line options
while getopts "s:d:z" opt; do
    case ${opt} in
        s)  
            search_term1=$OPTARG
            s_option=true
            ;;
        d)
            IFS=',' # Sets IFS to comma
            for arg in $OPTARG; do # Adds multiple arguments to array

                passedargs+=("$arg")
            done
            IFS=" " # Returns IFS to space
            
            search_term1=${passedargs[0]}
            search_term2=${passedargs[1]}
            d_option=true
            ;;
        z)
            z_option=true
            ;;
        *)
            echo -e "$OPTERR"
            exit 1
            ;;
    esac
done

# Checks if any options were set
if [[ "$s_option" = false ]] && [[ "$d_option" = false ]] && [[ "$z_option" = false ]]; then
    echo -e "${RED}No valid options were provided. Please provide at least one of the following options: -s, -d, -z.${NC}"
    exit 1
fi

# Checks if -s and -d were set together
if [[ "$s_option" = true ]] && [[ "$d_option" = true ]]; then
    echo -e "${RED}The -s and -d options cannot be set together.${NC}"
    exit 1
fi

# Checks if -z was set without -s or -d
if [[ "$z_option" = true ]] && [[ -z "$search_term1" ]]; then

    echo -e "${RED}The -z option requires either the -s or -d option to be set.${NC}"
    exit 1
fi

# Checks if 2 arguments were entered for -d
if [[ "$d_option" = true ]] && [[ -z $search_term2 ]]; then

    echo -e "${RED}-d requires 2 arguments. e.g. arg1,arg2. Exiting...${NC}"
    exit 1
fi

# Checks if 2 arguments are entered for -d
if [[ "$d_option" = true ]] && [[ -z $search_term1 ]]; then

    echo -e "${RED}-d requires 2 arguments. e.g. arg1,arg2. Exiting...${NC}"
    exit 1
fi

read -p "Enter name of log file to be processed: " input_file

if [[ -n "$search_term1" ]]; then

    output_file="results_$(date +%s).csv"
else    

    read -p "Enter name of the processed .csv file: " output_file
fi


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

    # Filters input file with 2 options
    if [[ -n "$search_term1" ]] && [[ -n "$search_term2" ]]; then
        grep "$search_term1" "$input_file" | grep "$search_term2" | while IFS= read -r line || [[ -n "$line" ]]; do
            parse_input_file "$line"
        done
    # Filters input file with 1 option   
    elif [[ -n "$search_term1" ]]; then
        grep "$search_term1" "$input_file" | while IFS= read -r line || [[ -n "$line" ]]; do
            parse_input_file "$line"
        done

    # If no options are set, command is executed below    
    else
        sed '1d' "$input_file" | while IFS= read -r line || [[ -n "$line" ]]; do
            parse_input_file "$line"
        done
    fi

    echo "$(($(wc -l < "$output_file") - 1)) records processed and the results written to $output_file as requested."

    if [[ "$z_option" = true ]]; then

        zip "${output_file%.csv}.zip" "$output_file"
        echo "The results file has also been zipped as requested."
    fi
fi

exit 0
