OLLAMA_MODEL="mistral"

check_ollama_model() {
    model_name="${1:-$OLLAMA_MODEL}"

    if ! command -v ollama &> /dev/null; then
        echo "ollama is not installed. Please install ollama first using the command setup_ollama."
        return 1
    fi

    if ! ollama list | grep -q "$model_name"; then
        echo "Model $model_name is not available. Please install it using the command setup_ollama_model."
        return 1
    fi
}

setup_ollama_model() {
    if ! command -v ollama &> /dev/null; then
        echo "ollama is not installed. Please install ollama first using the command setup_ollama."
        return 1
    fi

    echo "Please enter the model name you want to install (or press Enter to use the default 'mistral'):"
    echo "You can check https://ollama.com/library?sort=popular for available models."

    read -r model_name
    model_name="${model_name:-mistral}"

    if ollama pull "$model_name"; then
        if [ "$model_name" != "$OLLAMA_MODEL" ]; then
            echo "Do you want to set $model_name as the default model? (y/N)"
            read -r response
            response="${response:-n}"
            if [ "$response" = "y" ]; then
                OLLAMA_MODEL="$model_name"
                echo "Default model set to $OLLAMA_MODEL."
            fi
        fi
    else
        echo "Failed to pull model $model_name."
        return 1
    fi
}

setup_ollama() {
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Please install Homebrew first."
        return 1
    fi

    if brew install ollama; then
        setup_ollama_model
    fi
}

if ! command -v ollama &> /dev/null; then
  echo "ollama is not installed. Install it using the setup_ollama command."
elif ! check_ollama_model; then
  echo "No ollama model is installed. Install it using the setup_ollama_model command."
else

    ask_ollama() {
        local text="$*"
        local prompt="Acting as a bash specialist, return \
            command lines or explanation for '$text'. \
            Do not use markdown or any other formating, \
            ony using plain text and the previously mentioned tags."
        model_name="${OLLAMA_MODEL:-mistral}"

        echo "[User] Asking Ollama model $model_name for '$text'..."
        echo ""

        ollama run "$model_name" "$prompt"
    }

    alias llama=ask_ollama
fi
