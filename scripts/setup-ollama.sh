export DOTFILES_OLLAMA_DEFAULT_MODEL="mistral"

if ! command -v po &> /dev/null; then
    echo "commands.sh script not imported in .zshrc".
    echo "Please run ~/.dotfiles/bootstrap.sh to fix this issue."
    return 1
fi

check_ollama() {
    if ! command -v ollama &> /dev/null; then
        pw "ollama is not installed. Please install ollama first using the command setup_ollama."
        return 1
    fi

    po "ollama is installed."
}

check_ollama_model() {
    model_name="${1:-$DOTFILES_OLLAMA_DEFAULT_MODEL}"

    if ! command -v ollama &> /dev/null; then
        pw "ollama is not installed. Please install ollama first using the command setup_ollama."
        return 1
    fi

    if ! ollama list | grep -q "$model_name"; then
        pw "Model $model_name is not available. Please install it using the command setup_ollama_model."
        return 1
    fi

    po "ollama model $model_name is installed."
}

setup_ollama_model() {
    if ! command -v ollama &> /dev/null; then
        pw "ollama is not installed. Please install ollama first using the command setup_ollama."
        return 1
    fi

    po "Please enter the model name you want to install (or press Enter to use the default 'mistral'):"
    po "You can check https://ollama.com/library?sort=popular for available models."

    read -r model_name
    model_name="${model_name:-mistral}"

    if ollama pull "$model_name"; then
        if [ "$model_name" != "$DOTFILES_OLLAMA_DEFAULT_MODEL" ]; then
            po "Do you want to set $model_name as the default model? (y/N)"
            read -r response
            response="${response:-n}"
            if [ "$response" = "y" ]; then
                DOTFILES_OLLAMA_DEFAULT_MODEL="$model_name"
                po "Default model set to $DOTFILES_OLLAMA_DEFAULT_MODEL."
            fi
        fi
    else
        pe "Failed to pull model $model_name."
        return 1
    fi
}

setup_ollama() {
    if ! command -v brew &> /dev/null; then
        pe "Homebrew is not installed. Please install Homebrew first."
        return 1
    fi

    if brew install ollama; then
        setup_ollama_model
    fi
}

if [ -z "$DOTFILES_USER_PROMPT_SETUPS" ] || [ "$DOTFILES_USER_PROMPT_SETUPS" = "NO" ]; then
    return 0
fi

if ! command -v ollama &> /dev/null; then
  pw "ollama is not installed. Install it using the setup_ollama command."
elif ! ollama list | grep -q "$model_name"; then
  pw "No ollama model is installed. Install it using the setup_ollama_model command."
fi
