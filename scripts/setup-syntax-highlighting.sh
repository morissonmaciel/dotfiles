if ! alias po &>/dev/null; then
    echo "commands.sh script not imported in .zshrc".
    echo "Please run ~/.dotfiles/bootstrap.sh to fix this issue."
    return 1
fi

# Apply syntax highlighting to the command prompt
setup_syntax_highlighting() {
    git_clone_result=$(git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting)

    if [ $? -ne 0 ]; then
        pw "Git clone failed. Attempting to install using Homebrew..."

        if [ ! -z command -v brew ]; then
            pe "Homebrew not found. Please install it and try again."
            return 1
        fi

        brew install zsh-syntax-highlighting

        if [ $? -ne 0 ]; then
            pe "Failed to install zsh-syntax-highlighting using Homebrew."
            return 1
        fi
    fi

    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
}

if [ -z "$DOTFILES_USER_PROMPT_SETUPS" ] || [ "$DOTFILES_USER_PROMPT_SETUPS" = "NO" ]; then
    return 0
fi

if [ ! -f $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    pw "zsh-syntax-highlighting not found. Run 'setup_syntax_highlighting' to install it."
fi
