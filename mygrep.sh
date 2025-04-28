#!/bin/bash

# Check for help request
for arg in "$@"; do
    if [[ "$arg" == "--help" ]]; then
        echo "Usage: $0 [-n] [-v] pattern file"
        echo "Find text in files (case-in sensitive)"
        echo "options: "
        echo "  -n  show line number"
        echo "  -v  exclude matche"
        exit 0
    fi
done

n_flag=0
v_flag=0

# Handlle option
while getopts "nv" opt; do
    case $opt in
        n) n_flag=1 ;;
        v) v_flag=1 ;;
        *) echo "usage: $0 [-n] [-v] text file" >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

# Validate arguments
if [ $# -ne 2 ]; then
    echo "error: need to search text.txt and file_name" >&2
    exit 1
fi

search="$1"
file="$2"

# check if the file is exist
if [ ! -f "$file" ]; then
    echo "error: can not find the file named : '$file'" >&2
    exit 1
fi

# convert to lowercase 
low_search=$(echo "$search" | tr '[:upper:]' '[:lower:]')

line_num=0

# Process each line
while IFS= read -r line; do
    ((line_num++))
    
    # Case-insensitive compare
    low_line=$(echo "$line" | tr '[:upper:]' '[:lower:]')
    [[ "$low_line" == *"$low_search"* ]] && match=1 || match=0

    # Flip match if -v used
    ((v_flag)) && match=$((!match))

    # Print if matched
    if ((match)); then
        if ((n_flag)); then
            echo "$line_num:$line"
        else
            echo "$line"
        fi
    fi
done < "$file"
