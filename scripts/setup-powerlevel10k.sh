# Apply Powerlevel10k theme to the command prompt
setup_powerlevel10k() {
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.zsh/powerlevel10k
    source $HOME/.zsh/powerlevel10k/powerlevel10k.zsh-theme
}

if [ -z "$DOTFILES_USER_PROMPT_SETUPS" ] || [ "$DOTFILES_USER_PROMPT_SETUPS" = "NO" ]; then
    exit 0
fi

if [ ! -f $HOME/.zsh/powerlevel10k/powerlevel10k.zsh-theme ]; then
    echo "Powerlevel10k not found. Run 'setup_powerlevel10k' to install it."
fi
