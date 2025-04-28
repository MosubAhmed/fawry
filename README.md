mygrep.sh - Custom Grep Implementation
A simplified grep clone with case-insensitive search and filtering options

📦 Installation
Copy to bin: sudo cp mygrep.sh /usr/local/bin/mygrep

Make executable: chmod +x /usr/local/bin/mygrep

🚀 Features
Case-insensitive text search

-n: Show line numbers

-v: Invert matches

Combined flags support (-nv/-vn)

Error handling for missing files/arguments

🛠️ Implementation
Argument Handling:

bash
while getopts "nv" opt; do
    case $opt in
        n) show_numbers=1 ;;  # -n flag
        v) invert_match=1 ;;  # -v flag
        *) exit 1 ;;
    esac
done
shift $((OPTIND - 1))
Uses POSIX-compliant getopts for option parsing. Handles flag combinations through bitwise operations.

Core Logic:

bash
while IFS= read -r line; do
    ((line_num++))
    lower_line=$(echo "$line" | tr '[:upper:]' '[:lower:]')
    [[ "$lower_line" == *"$search_term"* ]] && match=1 || match=0
    ((invert_match)) && match=$((!match))
Converts lines/search term to lowercase once

Uses wildcard matching for substring search

Inverts match status using boolean negation

✅ Validation
Test File (testfile.txt):

Hello world
This is a test
another test line
HELLO AGAIN
Don't match this line
Testing one two three
Test Commands:

bash
mygrep hello testfile.txt               # Basic match
mygrep -n hello testfile.txt            # Line numbers
mygrep -vn hello testfile.txt           # Inverted + line numbers
mygrep -v testfile.txt                  # Error: Missing search term

🧠 Development Challenges
Main Difficulty: Option combination handling (-nv/-vn)
Solution: Used getopts for native flag stacking support and maintained state with boolean flags

![Screenshot From 2025-04-28 13-52-45](https://github.com/user-attachments/assets/37e33629-6efd-428d-a449-25e263e693f3)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
