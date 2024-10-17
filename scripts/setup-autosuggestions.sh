if ! alias po &>/dev/null; then
    alias po="echo"
    alias pe="echo"
    alias pw="echo"
fi

# Apply autosuggestions to the command prompt
setup_autosuggestions() {
    git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/zsh-autosuggestions
    source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
}

if [ -z "$DOTFILES_USER_PROMPT_SETUPS" ] || [ "$DOTFILES_USER_PROMPT_SETUPS" = "NO" ]; then
    exit 0
fi

if [ ! -f $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    pw "zsh-autosuggestions not found. Run 'setup_autosuggestions' to install it."
fi
