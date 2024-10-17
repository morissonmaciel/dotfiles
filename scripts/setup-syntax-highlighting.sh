# Apply syntax highlighting to the command prompt
setup_syntax_highlighting() {
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting
    source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
}

if [ "$SHOW_SETUP_MESSAGE" != "true" ]; then
    exit 0
fi

if [ ! -f $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    echo "zsh-syntax-highlighting not found. Run 'setup_syntax_highlighting' to install it."
fi
