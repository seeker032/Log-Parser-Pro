#!/bin/bash

# Student Name: Harvey Roxas
# Student Number: 1062 6057

# Message to the professor:

# This was quite an interesting experience, coming from someone who hadn’t delved deeply into shell scripting 
# prior to this unit. I’ve invested time in Visual Basic, C++, Java, and Python (among others). Because all of these are 
# object-oriented programming languages, my skills transfer. However, some of them don’t transfer in Bash. There are also some weird 
# quirks about this scripting language. For example, where Java or Python will use libraries, Bash typically uses other 
# programs like sed and grep. This certainly makes it a mishmash of various functionalities, like glue holding everything 
# together. It was difficult, to be sure, but I'm quite confident I'll have you to thank if I ever get into Linux Sysadmin 
# stuff in the future.

RED='\033[0;31m' # Colours error messages
BLUE='\033[0;34m' # Colours file names
NC='\033[0m' # Turns off colours
OPTERR="${RED}Invalid option or missing argument error - exiting...${NC}" 
s_option=false # Initialises variables for later use
d_option=false
z_option=false

# Defines a function to parse the input file
parse_input_file() {

    local line=$1
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
}

# Parses command line options
while getopts "s:d:z" opt; do 
    case ${opt} in
        s)  
            search_term1=$OPTARG # Adds argument to variable $search_term1
            s_option=true # Sets value of variable $s_option to true for later use
            ;;
        d)
            IFS=',' # Sets IFS to comma
            for arg in $OPTARG; do # Adds multiple arguments to array

                passedargs+=("$arg")
            done
            IFS=" " # Returns IFS to space
            
            # Assigns arguments to 2 variables
            search_term1=${passedargs[0]} 
            search_term2=${passedargs[1]}
            d_option=true # Sets value of variable $d_option to true for later use
            ;;
        z)
            z_option=true # Sets value of variable $z_option to true for later use
            ;;
        *)
            echo -e "$OPTERR" # Displays error message
            exit 1 # Exits program
            ;;
    esac
done

# Shifts positional parameters to the left for input validation purposes (3rd if statement)
shift $((OPTIND -1))

# Prevents special characters (except period and slash) from being accepted as arguments ([^./a-zA-Z0-9]). 
if [[ $search_term1 =~ [^./a-zA-Z0-9] ]] || [[ $arg =~ [^./a-zA-Z0-9] ]]; then
   echo -e "${RED}Special characters cannot be accepted as filters, except periods and slashes.${NC}" 
   exit 1
fi

# Checks if -z was set ($z_option = true) without -s or -d (-z $search_term1)
if [[ "$z_option" = true ]] && [[ -z "$search_term1" ]]; then

    echo -e "${RED}The -z option requires either the -s or -d option to be set. Exiting...${NC}" # echo -e ensures that colour is displayed by recognising escape sequences
    exit 1 # Exits program
fi

# Checks if the number of arguments passed to script is greater than 0 ($# -gt 0), effectively only allowing valid flags to be provided
if [[ $# -gt 0 ]]; then
    echo -e "${RED}No valid flags provided. Only -s, -d, and -z options are allowed. Exiting...${NC}"
    exit 1 # Exits program
fi

# Checks if -s and -d were set together
if [[ "$s_option" = true ]] && [[ "$d_option" = true ]]; then
    echo -e "${RED}The -s and -d options cannot be set together. Exiting...${NC}"
    exit 1 # Exits program
fi

# Checks if 2 arguments were entered -d. -z is used to check if $search_term2 is null
if [[ "$d_option" = true ]] && [[ -z $search_term2 ]]; then

    echo -e "${RED}-d requires 2 arguments separated by a comma. e.g. arg1,arg2. Exiting...${NC}"
    exit 1 # Exits program
fi

# Checks if 2 arguments are entered for -d. -z is used to check if $search_term1 is null
if [[ "$d_option" = true ]] && [[ -z $search_term1 ]]; then

    echo -e "${RED}-d requires 2 arguments separated by a comma. e.g. arg1,arg2. Exiting...${NC}"
    exit 1 # Exits program
fi

# Asks user for input file. -r prevents backslash escapes from being interpreted. -p allows script to display prompt before read command executes
read -r -p "Enter name of log file to be processed: " input_file

# Generates random output file name if options were used
if [[ -n "$search_term1" ]]; then

    output_file="results_$(date +%s).csv" # date +%s outputs number of seconds since unix epoch

# Asks for name of output file name if no options were used
else    
    read -r -p "Enter name of the processed .csv file: " output_file
fi
# Checks if input/output files do not end in .csv ([file] != *.csv), or input file is nonexistent (! -f), or input file is empty (! -s)
if [[ "$input_file" != *.csv ]] || [[ "$output_file" != *.csv ]] || [[ ! -f "$input_file" ]] || [[ ! -s "$input_file" ]]; then
    echo -e "You need to provide the name/s of one or two .csv files (when applicable)
        - the name of the log file to be processed and,
        - the name you want for the .csv file for the processed results to be placed in, e.g.
                    ${BLUE}weblogname.csv${NC} 
                    ${BLUE}outputfilename.csv${NC}
Please try again." 

else
    # Checks if output_file already exists
    if [[ -f "$output_file" ]]; then
        rm "$output_file" # Removes output file to prevent appending to it
    fi

    # Puts rearranged header to output file as the first line using redirection
    echo "IP,Date,Method,URL,Protocol,Status" >> "$output_file" 
    echo "Processing..."

    # Filters input file with 2 options
    if [[ -n "$search_term1" ]] && [[ -n "$search_term2" ]]; then
        # Retrieves lines containing search_term1 and search_term2 (grep) from input file, loops through each line (while IFS= read -r) and places them to variable $line, and ensures last line is read (-n "$line") 
        grep "$search_term1" "$input_file" | grep "$search_term2" | while IFS= read -r line || [[ -n "$line" ]]; do

            parse_input_file "$line" # Calls parse_input_file function
        done
    # Filters input file with 1 option   
    elif [[ -n "$search_term1" ]]; then
        # Retrieves lines containing search_term1 (grep) from input file, loops through each line (while IFS= read -r) and places them to variable $line, and ensures last line is read (-n "$line") 
        grep "$search_term1" "$input_file" | while IFS= read -r line || [[ -n "$line" ]]; do 
        
            parse_input_file "$line" # Calls parse_input_file function
        done

    # If no options are set, scripts goes to default setting   
    else
        # Reads lines (read -r line) from input file using a while loop, skipping the first line (sed '1d'), and ensures the last line is read (-n "$line")
        sed '1d' "$input_file" | while IFS= read -r line || [[ -n "$line" ]]; do 
                                                                               
            parse_input_file "$line" # Calls parse_input_file function
        done
    fi

    # Calculates the number of lines in the output file and puts it into variable $total_records
    total_records=$(wc -l "$output_file" | awk '{print $1}') # wc -l displays number of lines in output file, piped to awk '{print $1}' to retrieve number

    # Checks if there is only one line in output file. One line = no records were processed
    if [[ $total_records == 1 ]]; then

        echo "0 records processed.." # Informs user of such
        rm "$output_file" # Deletes output file
    
    else
        # Informs user of such, $total_records subtracted by 1 to ignore header
        echo -e "$((total_records - 1)) records processed and the results written to ${BLUE}$output_file${NC} as requested." 
    fi

    # Checks if -z option was set
    if [[ "$z_option" = true ]]; then

        zip "${output_file%.csv}.zip" "$output_file" # Zips output file
        echo "The results file has also been zipped as requested." # Informs user of such
    fi
fi

exit 0
