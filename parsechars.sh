#!/bin/bash

# Student Name: Harvey Doctor Roxas

# The script is encapsulated in an infinite while loop, which allows user termination by entering "-q." This loop also continues until the final output is shown.

# Before processing the user’s chosen file, the loop checks for three things: (1) the user entered "-q" to quit, (2) the chosen file doesn't exist, and (3) 
# the chosen file is empty. If the file fails these checks, the user is prompted to re-enter a valid filename.

# Once the file passes the checks, each line is processed using a "while" loop with “IFS= read -r” to accept spaces as characters. Doing this avoids the use 
# of the “cat” command in “for” loop statements, which treats spaces as separators between words. 

# Following this, the script then uses various techniques to analyse the characters: 

# 1. To specify the allowable/disallowable range, regex is enclosed with square brackets (e.g., [AEIOU02468&#!\$-] for allowed characters). The "grep" command 
#    then extracts these specific characters from each line, and the "-o" option allows grep to find out which characters match the regex. This seemed more straightforward 
#    than using the cut command to isolate individual characters for regex matching. 

# 2. Pipes (|) are used to connect commands for further data manipulation. Commands like “wc -l” and “wc -m” piped with grep and echo enable character counting.

# 3. Command substitution ($(..)) is also used, which is important in storing processed data (like character counts) in variables for later display. This is also 
#    important for readability by keeping the code organised.

# 4. To calculate the number of disallowed characters, the script uses a simple subtraction. This is more efficient than using command substitions.

# Finally, after reversing allowed/disallowed characters with loops using decrements and indexed arrays (not sure if this part can be made more efficient by using sed), 
# the script displays the final output in colour using "echo -e”.

RED='\033[0;31m' # Highlights disallowed characters and error message
GREEN='\033[0;32m' # Highlights allowed characters
BLUE='\033[0;34m' # Highlights the full password candidate
NC='\033[0m' # Switches off the application of a colour to output

while true; do # Infinite loop to keep prompting user for file name
    
    read -p "Enter the name of the candidate password file (including ext) [Enter -q to quit]: " fileName # Prompts user for file name and stores it to a variable

    if [[ $fileName == "-q" ]]; then # Breaks infinite loop if user enters -q on prompt
        exit 1 # Exits program

    elif [[ ! -f $fileName ]]; then # If file is nonexistent (! -f), loop is restarted which prompts user to re-enter file name
        echo -e "${RED}The file does not exist. Please try another file name...${NC}" # 'echo' outputs message, '-e' ensures that colour is displayed by recognising escape sequences

    elif [[ ! -s $fileName ]]; then # if file is empty (! -s), loop is restarted which prompts user to re-enter file name
        echo -e "${RED}The file is empty. Please try another file name...${NC}" # Outputs message, formatted by colour codes
    
    else # If input passes checks, code is executed below
        while IFS= read -r line || [[ -n $line ]]; do # Loops through each line in specified file (using read -r ) and stores them in variable $line. 
                                                      # '-n $line' ensures that the last line is read
            
            totalCharCount=$(echo -n "$line" | wc -m) # Retrieves line and displays character count using 'wc -m' and stores them in a variable
                                                      # '-n' suppresses new line in 'echo'
            allowedCount=$(echo -n "$line" | grep -o "[AEIOU02468&#!\$-]" | wc -l) # Retrieves allowed characters in each line using grep -o [regex], 
                                                                                   # counts number of lines (allowed characters) using "wc -l", and stores them in a variable
            disallowedCount=$((totalCharCount-allowedCount)) # Calculates number of disallowed characters and stores them in a variable
            allowedChars=$(echo "$line" | grep -o "[AEIOU02468&#!\$-]" | tr -d '\n') # Retrieves allowed/disallowed characters using grep -o [regex] and stores them in 2 variables
            disallowedChars=$(echo "$line" | grep -o "[^AEIOU02468&#!\$-]" | tr -d '\n') # tr -d '\n' is used to remove newlines for each character in string

            # Reverses string for allowedChars
            rev="" # Initialises $rev with empty value to prevent disallowed characters from overflowing to allowedChars
            for (( pos=${#allowedChars}-1; pos>=0; pos-- )); do # Loop counts backwards from last character of allowedChars

                rev="$rev${allowedChars:$pos:1}" # Retrieves each character at index $pos and places them into $rev one-by-one
            done
            allowedChars=$rev # Places reversed string to allowedChars

            # Reverses string for disallowedChars
            rev="" # Initialises $rev with empty value to prevent allowed characters from overflowing to disallowedChars
            for (( pos=${#disallowedChars}-1; pos>=0; pos-- )); do # Loop counts backwards from last character of disallowedChars

                rev="$rev${disallowedChars:$pos:1}" # Retrieves each character at index $pos and places them into $rev one-by-one
            done
            disallowedChars=$rev # Places reversed string to disallowedChars

            echo -e "${BLUE}$line${NC} [T: $totalCharCount] [A]: ${GREEN}$allowedChars${NC} ($allowedCount) [D]: ${RED}$disallowedChars${NC} ($disallowedCount)]" # Prints output to terminal

        done < "$fileName" # inputs data of user's chosen file to read statement at beginning of while loop

        exit 1 # Exits program
    fi
done
exit 0 # Exits program
