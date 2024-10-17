ask_ollama() {
    # Check if Ollama is available
    if ! check_ollama; then
        return 1
    fi

    # Check if the Ollama model is available
    if ! check_ollama_model; then
        return 1
    fi

    local type="${1:-}"
    shift
    local text="$*"

    local model_name="${OLLAMA_MODEL:-mistral}"
    local prompt

    if [ "$type" = "explain" ]; then
        prompt="Acting as a bash specialist, provide an explanation for '$text'. \
        Do not use markdown or any other formatting, only using plain text."
    elif [ "$type" = "command" ]; then
        prompt="Acting as a bash specialist, return command lines for '$text'. \
        Do not use markdown or any other formatting, only using plain text."
    elif [ "$type" = "ask" ]; then
        prompt="Acting as a bash specialist, provide an answer for '$text'. \
        Do not use markdown or any other formatting, only using plain text."
    elif [ "$type" = "--help" ]; then
        echo "Usage: llama [explain|command|ask] [text]"
        echo "Types:"
        echo "  explain - Provide an explanation for the given text"
        echo "  command - Return command lines for the given text"
        echo "  ask     - Provide an answer for the given text"
        echo "  --help  - Show this help message"
        return 0
    else
        echo "Invalid type. Use --help for usage information."
        return 1
    fi

    ollama run $model_name "$prompt"
}

alias llama=ask_ollama
