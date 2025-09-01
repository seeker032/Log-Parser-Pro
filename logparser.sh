#!/bin/bash

# Student Name: Harvey Doctor Roxas
# Student Number: 1062 6057

# The script parses CSV log files and outputs to another CSV file under certain parameters. 

# The script validates user input before processing. It checks: (1) two arguments are entered, (2&3) input and output files end with .csv, 
# (4) input file isn’t empty, (5) input file exists, and (6) output file doesn’t exist. This ensures the script’s main logic executes correctly.
# Conditions 1-5 halt the main logic if the input is invalid. The 6th condition deletes any existing output file to avoid appending to it. This is 
# useful for debugging purposes and repeated script usage.

# Once the files pass validation, each line is processed using a "while" loop with "IFS= read -r" to accept spaces as characters. 

# Following this, the script uses various techniques to parse every line in the input file:

# 1. Pipes (|) connect the "echo", "cut", and "sed" commands for data manipulation.
# 2. Command substitution ($(…)) is used for storing processed data in variables for display and code organisation. 
# 3. The "cut" command is used to split each line into fields depending on the delimiter (commas, whitespaces, colon, question mark) to extract the 
#    5 fields required for the output .csv file.
# 4. The "sed" command is used to remove leading brackets and backslashes from the date and url, while the "cut" command is also used to extract the date and url
#    to match their required formats (e.g. 29/Nov/2017 and login.php)

# Once the current line has been parsed, data is redirected to the output file using echo and variables. This parsing continues until the last line.
# Finally, the script outputs the number of lines processed to the terminal using "wc -l" with "echo".

BLUE='\033[0;34m' # Highlights the required format in terminal
NC='\033[0m' # Switches off the application of a colour to output

input_file=$1 # Puts value of $1 and $2 to variables $input_file and $output_file 
output_file=$2 # to improve code readability

if [[ $# -ne 2 ]] || [[ "$input_file" != *.csv ]] || [[ "$output_file" != *.csv ]] || [[ ! -f "$input_file" ]] || [[ ! -s "$input_file" ]]; then # If number of arguments passed to the script is not equal to 
                                                                                                                                                 # 2 ($# -ne 2), or input/output files do not end in .csv ([file] != *.csv), or input file 
                                                                                                                                                 # is nonexistent (! -f), or input file is empty (! -s), rest of the script is not executed    

    echo "You need to provide the names of two (2) .csv files" # 'echo' outputs message
    echo "  - the name of the log file to be processed and,"
    echo "  - the name you want for the .csv file for the processed results to be placed in, e.g."
    echo -e "   ${BLUE}./logparser.sh weblogname.csv outputfilename.csv${NC}" # '-e' ensures that colour is displayed by recognising escape sequences
    echo "Please try again." 

else # Script continues if input and output file were successfully validated
    if [[ -f "$output_file" ]]; then  # Deletes output file if it already exists using the rm command,
        rm "$output_file"             # preventing script to add on to existing file from last line

    fi

    echo "IP,Date,Method,URL,Protocol,Status" >> "$output_file" # Prints the header to output file
    echo "Processing..." # Lets user know that the program currently processes the input file

    # Parses the input file
    sed '1d' "$input_file" | while IFS= read -r line || [[ -n "$line" ]]; do # Loops through each line in specified file (using read -r) and
                                                                             # stores them in variable $line. sed '1d' ensures first line
                                                                             # is not read before loop starts. -n $line ensures that the last line is read

        ip_address=$(echo "$line" | cut -d ',' -f 1) # Retrieves line using echo, extracts IP address (1st field of line [-f 1]) using cut with comma as 
                                                     # delimiter (-d ',') and stores final value into variable $ip_address

        date=$(echo "$line" | cut -d ',' -f 2 | cut -d ':' -f 1 | sed 's/\[//') # Retrieves line using echo, extracts date and time (2nd field of line [-f 1]) using 
                                                                                # cut with comma as delimiter (-d ','), splits field further using another 
                                                                                # cut command with delimiter ':' extracting date without the time (-f 1), then 
                                                                                # removes bracket ([) using sed and stores final value to variable $date

        method=$(echo "$line" | cut -d ',' -f 3 | cut -d ' ' -f 1) # Retrieves line using echo, extracts method, url, and protocol (3rd field of line [-f 3]) using cut with 
                                                                   # comma as delimiter (-d ','), splits field further using another cut command with whitespace as 
                                                                   # delimiter, extracting method (1st field -f 1) without the whitespace, and stores final value to 
                                                                   # variable $method

        url=$(echo "$line" | cut -d ',' -f 3 | cut -d ' ' -f 2 | cut -d '?' -f 1 | sed 's/\///') # Retrieves line using echo, extracts method, url, and protocol 
                                                                                                 # (3rd field of line [-f 3]) using cut with comma as delimiter (-d ','), 
                                                                                                 # splits field further using another command with whitespace as delimiter, 
                                                                                                 # extracting url (2nd field -f 2), splits field further using another cut
                                                                                                 # command with '?' as delimiter, extracting the first part before question mark
                                                                                                 # which removes query parameters from URL, then removes leading slash from URL 
                                                                                                 # using sed, and stores final value to variable $url

        protocol=$(echo "$line" | cut -d ',' -f 3 | cut -d ' ' -f 3) # Retrieves line using echo, extracts method, url, and protocol (3rd field of line [-f 3]) using cut with 
                                                                     # comma as delimiter (-d ','), splits field further using another command with space as delimiter, 
                                                                     # extracting protocol (3rd field [-f 3]), and stores final value to variable $protocol

        status=$(echo "$line" | cut -d ',' -f 4) # Retrieves line using echo, extracts status (4th field of line [-f 4]) using cut with comma as delimiter, and puts final
                                                 # value to variable #status

        echo "$ip_address,$date,$method,$url,$protocol,$status" >> "$output_file" # Prints each parsed line to output file

    done 

    echo "$(($(wc -l < "$output_file") - 1)) records processed..." # Counts number of lines in output file using wc -l, substracts the total by 1 
                                                                   # (to ignore header) then outputs the result using echo
fi

exit 0 # Exits program

