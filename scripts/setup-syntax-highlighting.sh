if ! alias po &>/dev/null; then
    alias po="echo"
    alias pe="echo"
    alias pw="echo"
fi

# Apply syntax highlighting to the command prompt
setup_syntax_highlighting() {
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting
    source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
}

if [ -z "$DOTFILES_USER_PROMPT_SETUPS" ] || [ "$DOTFILES_USER_PROMPT_SETUPS" = "NO" ]; then
    exit 0
fi

if [ ! -f $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    pw "zsh-syntax-highlighting not found. Run 'setup_syntax_highlighting' to install it."
fi
