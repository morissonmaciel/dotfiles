
# Function to output colored messages
output_colored_message() {
    local color_code="$1"
    local message="$2"
    echo -e "${color_code}${message}\e[0m"
}

# Function to detect OS name
get_os_name() {
    uname -s
}

# Function to suggest installing 'ollama'
suggest_install_ollama() {
    local os_name="$1"
    output_colored_message "\e[33m" "You can install Ollama as follows:"
    if [[ "$os_name" == "Darwin" ]]; then
        output_colored_message "\e[32m" "brew install ollama"
    elif [[ "$os_name" == "Linux" ]]; then
        output_colored_message "\e[32m" "Follow the instructions at https://ollama.ai/downloads"
    else
        output_colored_message "\e[32m" "Visit https://ollama.ai/downloads for installation instructions."
    fi
}

# Function to check if 'ollama' is installed
check_ollama() {
    if ! command -v ollama >/dev/null 2>&1; then
        output_colored_message "\e[31m" "Error: The 'ollama' command was not found."
        local os_name=$(get_os_name)
        suggest_install_ollama "$os_name"
        return 1
    fi
}

# Function to escape single quotes in user input
escape_single_quotes() {
    local input="$1"
    echo "$input" | sed "s/'/'\\\\''/g"
}

# Function to extract code within [bash][/bash] tags
extract_code() {
    local input="$1"
    echo "$input" | sed -n '/\[bash\]/,/\[\/bash\]/p' | sed '1d;$d' | sed 's/\[bash\]//g' | sed 's/\[\/bash\]//g'
}

# Function to suggest installing 'bat'
suggest_install_bat() {
    local os_name="$1"
    output_colored_message "\e[33m" "To enable syntax highlighting, install 'bat' as follows:"
    if [[ "$os_name" == "Darwin" ]]; then
        output_colored_message "\e[32m" "brew install bat"
    elif [[ "$os_name" == "Linux" ]]; then
        if command -v apt-get >/dev/null 2>&1; then
            output_colored_message "\e[32m" "sudo apt-get install bat"
        elif command -v yum >/dev/null 2>&1; then
            output_colored_message "\e[32m" "sudo yum install bat"
        elif command -v pacman >/dev/null 2>&1; then
            output_colored_message "\e[32m" "sudo pacman -S bat"
        else
            output_colored_message "\e[32m" "Visit https://github.com/sharkdp/bat#installation for manual installation instructions."
        fi
    else
        output_colored_message "\e[32m" "Visit https://github.com/sharkdp/bat#installation for manual installation instructions."
    fi
}

# Function to colorize code using 'bat', or output code and suggest installing 'bat'
colorize_code() {
    local code="$1"
    if command -v bat >/dev/null 2>&1; then
        echo "$code" | bat --language bash --style=plain --paging=never --theme=ansi
    else
        echo "$code"
        local os_name=$(get_os_name)
        suggest_install_bat "$os_name"
    fi
}

# Function to process command result
process_command_result() {
    local result="$1"

    # Check if result contains [bash] tags
    if echo "$result" | grep -q '\[bash\]'; then
        # Extract code within [bash][/bash] tags
        local code
        code=$(extract_code "$result")
        # Colorize code or suggest installing 'bat'
        colorize_code "$code"
    else
        # No [bash] tags found, try to get multiline contents inside ```bash ``` markdown
        if echo "$result" | grep -q '```bash'; then
            local code
            code=$(echo "$result" | sed -n '/```bash/,/```/p' | sed '1d;$d')
            colorize_code "$code"
        else
            # No special tags found, echo the whole result
            echo "$result"
        fi
    fi
}

# Main 'ask' function
ask() {
    local action="$1"
    shift
    local user_input="$*"  # Join all arguments into a single string

    # Check if an action was provided
    if [[ -z "$action" ]]; then
        echo "Usage: ask [command|help] <your question>"
        return 1
    fi

    # Check if 'ollama' is installed
    check_ollama || return 1

    # Set the model from the environment variable or default to 'mistral'
    local ollama_model="${OLLAMA_MODEL:-mistral}"

    # Escape single quotes in user_input to avoid issues in string construction
    local escaped_input
    escaped_input=$(escape_single_quotes "$user_input")

    # Construct the prompt based on the action
    local prompt
    if [[ "$action" == "command" ]]; then
    prompt="Acting as a bash specialist, return \
        command lines for '$escaped_input' inside [bash][/bash] tags. \
        Do not use markdown or any other formating, \
        ony using plain text and the previously mentioned tags."
    elif [[ "$action" == "help" ]]; then
        prompt="Acting as a bash specialist, provide assistance on \
        '$escaped_input'. Do not use markdown or any other formating, \
        only using plain text."
    else
        echo "Unknown action: '$action'. Use 'command' or 'help'."
        echo "Usage: ask [command|help] <your question>"
        return 1
    fi

    # Process the result based on the action
    if [[ "$action" == "command" ]]; then
        local result
        result=$(ollama run "$ollama_model" "'$prompt'")
        process_command_result "$result"
    elif [[ "$action" == "help" ]]; then
        # Just display the result directly
        ollama run "$ollama_model" "'$prompt'"
    fi
}
