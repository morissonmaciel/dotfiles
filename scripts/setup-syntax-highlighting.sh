if ! alias po &>/dev/null; then
    echo "commands.sh script not imported in .zshrc".
    echo "Please run ~/.dotfiles/bootstrap.sh to fix this issue."
    return 1
fi

# Apply syntax highlighting to the command prompt
setup_syntax_highlighting() {
    git_clone_result=$(git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting)

    if [ $? -ne 0 ]; then
        pw "Git clone failed. Attempting to download the raw content of the latest release..."

        raw_content_url="https://raw.githubusercontent.com/zsh-users/zsh-syntax-highlighting/master/zsh-syntax-highlighting.zsh"
        mkdir -p $HOME/.zsh/zsh-syntax-highlighting
        curl -L $raw_content_url -o $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

        if [ $? -ne 0 ]; then
            pe "Failed to download the raw content of the latest release."
            return 1
        fi
    fi

    source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
}

if [ -z "$DOTFILES_USER_PROMPT_SETUPS" ] || [ "$DOTFILES_USER_PROMPT_SETUPS" = "NO" ]; then
    return 0
fi

if [ ! -f $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    pw "zsh-syntax-highlighting not found. Run 'setup_syntax_highlighting' to install it."
fi
