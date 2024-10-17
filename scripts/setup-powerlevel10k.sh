if ! command -v po &> /dev/null; then
    echo "commands.sh script not imported in .zshrc".
    echo "Please run ~/.dotfiles/bootstrap.sh to fix this issue."
    return 1
fi

# Apply Powerlevel10k theme to the command prompt
setup_powerlevel10k() {
    git_clone_result=$(git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.zsh/powerlevel10k)

    if [ $? -ne 0 ]; then
        pe "Git clone failed. Please check your internet connection and try again."
        return 1
    fi

    source $HOME/.zsh/powerlevel10k/powerlevel10k.zsh-theme
}

if [ -z "$DOTFILES_USER_PROMPT_SETUPS" ] || [ "$DOTFILES_USER_PROMPT_SETUPS" = "NO" ]; then
    return 0
fi

if [ ! -f $HOME/.zsh/powerlevel10k/powerlevel10k.zsh-theme ]; then
    pw "Powerlevel10k not found. Run 'setup_powerlevel10k' to install it."
fi
