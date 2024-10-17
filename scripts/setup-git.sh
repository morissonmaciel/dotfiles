setup_git() {
    local git_not_found=false

    if ! command -v git &> /dev/null; then
        git_not_found=true
    fi

    if $git_not_found; then
        if ! command -v brew &> /dev/null; then
            echo "Cannot install git. Homebrew is not installed."
            exit 1
        fi
        brew install git
    fi

    if command -v git &> /dev/null; then
        echo "git is installed."
    fi
}

if [ -z "$DOTFILES_USER_PROMPT_SETUPS" ] || [ "$DOTFILES_USER_PROMPT_SETUPS" = "NO" ]; then
    exit 0
fi

if [ ! command -v git &> /dev/null ]; then
    echo "git is not installed. Install it using the command setup_git."
fi
