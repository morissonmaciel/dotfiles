if ! alias po &>/dev/null; then
    echo "commands.sh script not imported in .zshrc".
    echo "Please run ~/.dotfiles/bootstrap.sh to fix this issue."
    return 1
fi

setup_git() {
    local git_not_found=false

    if ! command -v git &> /dev/null; then
        git_not_found=true
    fi

    if $git_not_found; then
        if ! command -v brew &> /dev/null; then
            pe "Cannot install git. Homebrew is not installed."
            exit 1
        fi
        brew install git
    fi

    if command -v git &> /dev/null; then
        po "git is installed."
    fi
}

if [ -z "$DOTFILES_USER_PROMPT_SETUPS" ] || [ "$DOTFILES_USER_PROMPT_SETUPS" = "NO" ]; then
    return 0
fi

if [ ! command -v git &> /dev/null ]; then
    pw "git is not installed. Install it using the command setup_git."
fi
