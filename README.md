I developed a mygrep.sh script and placed it in the /usr/local/bin directory, ensuring its executability from any location.
also i made sure that the file is excutable by running this command chmod +x mygrep.sh 

The most challenging aspect was argument parsing and validation, specifically:
Option Combinations: Ensuring -nv and -vn behaved identically required proper getopts configuration and flag management.



1. Initial Setup
#!/bin/bash: Specifies this should run in the Bash shell


2. Help Documentation
for arg in "$@"; do
    if [[ "$arg" == "--help" ]]; then
        echo "Usage: $0 [-n] [-v] pattern file"
        echo "Find text in files (case-insensitive)"
        echo "Options:"
        echo "  -n  Show line numbers"
        echo "  -v  Exclude matches"
        exit 0
    fi
done

- Checks if user typed --help
- Prints usage instructions and exits if help requested



3. Option Flags Setup
n_flag=0  
v_flag=0  

- Initialize toggle switches for options (-n and -v)



4. Option Handling
while getopts "nv" opt; do
    case $opt in
        n) n_flag=1 ;;     
        v) v_flag=1 ;;    
        *) echo "Usage: $0 [-n] [-v] text file" >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))    



-getopts processes -n/-v flags
-shift removes options from arguments list
-Handles invalid options by showing usage




5. Input Validation
if [ $# -ne 2 ]; then
    echo "Error: Need search text and filename" >&2
    exit 1
fi

search="$1"
file="$2"

if [ ! -f "$file" ]; then
    echo "Error: Can't find '$file'" >&2
    exit 1
fi

- Checks for exactly 2 remaining arguments
- Verifies input file exists
- Stores search term and filename



6. Case Insensitivity Setup
low_search=$(echo "$search" | tr '[:upper:]' '[:lower:]')

- Converts search term to lowercase once (optimization)




7. File Processing

line_num=0

while IFS= read -r line; do
    ((line_num++))
    
    # Convert line to lowercase
    low_line=$(echo "$line" | tr '[:upper:]' '[:lower:]')
    
    # Check for match
    [[ "$low_line" == *"$low_search"* ]] && match=1 || match=0

- IFS= read -r line: Reads file line-by-line preserving spaces
- line_num tracks current line number
- Converts each line to lowercase for comparison
- Uses wildcard match (*) to find substring



8. Match Inversion
    # Flip match if -v used
    ((v_flag)) && match=$((!match))

- If -v flag is active, reverses match status
- Example: Turns 1 (match) → 0 (no match)



9. Output Formatting

    if ((match)); then
        if ((n_flag)); then
            echo "$line_num:$line"
        else
            echo "$line"
        fi
    fi
done < "$file"


- Prints line if matched
- Adds line numbers when -n flag is active
- done < "$file" feeds the file into the loop


10. After creating the testfile.txt i made sure that all the test cases is correct and running as it should be

![Screenshot From 2025-04-28 13-52-45](https://github.com/user-attachments/assets/37e33629-6efd-428d-a449-25e263e693f3)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
