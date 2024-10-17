if ! command -v po &> /dev/null; then
    echo "commands.sh script not imported in .zshrc".
    echo "Please run ~/.dotfiles/bootstrap.sh to fix this issue."
    return 1
fi

# Apply autosuggestions to the command prompt
setup_autosuggestions() {
    git_clone_result=$(git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/zsh-autosuggestions)

    if [ $? -ne 0 ]; then
        pw "Git clone failed. Please check your internet connection and try again."
        return 1
    fi

    source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
}

if [ -z "$DOTFILES_USER_PROMPT_SETUPS" ] || [ "$DOTFILES_USER_PROMPT_SETUPS" = "NO" ]; then
    return 0
fi

if [ ! -f $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    pw "zsh-autosuggestions not found. Run 'setup_autosuggestions' to install it."
fi
