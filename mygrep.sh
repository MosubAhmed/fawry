#!/bin/bash

# Check for help request
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

n_flag=0
v_flag=0

# Handle options
while getopts "nv" opt; do
    case $opt in
        n) n_flag=1 ;;
        v) v_flag=1 ;;
        *) echo "Usage: $0 [-n] [-v] text file" >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

# Validate arguments
if [ $# -ne 2 ]; then
    echo "Error: Need search text and filename" >&2
    exit 1
fi

search="$1"
file="$2"

# Check file exists
if [ ! -f "$file" ]; then
    echo "Error: Can't find '$file'" >&2
    exit 1
fi

# Convert search text to lowercase once
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
