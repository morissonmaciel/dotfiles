if ! alias po &>/dev/null; then
    alias po="echo"
    alias pe="echo"
    alias pw="echo"
fi

# Apply autosuggestions to the command prompt
setup_autosuggestions() {
    git_clone_result=$(git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/zsh-autosuggestions)

    if [ $? -ne 0 ]; then
        pw "Git clone failed. Attempting to download the raw content of the latest release..."

        raw_content_url="https://raw.githubusercontent.com/zsh-users/zsh-autosuggestions/master/zsh-autosuggestions.zsh"
        mkdir -p $HOME/.zsh/zsh-autosuggestions
        curl -L $raw_content_url -o $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

        if [ $? -ne 0 ]; then
            pe "Failed to download the raw content of the latest release."
            return 1
        fi
    fi

    source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
}

if [ -z "$DOTFILES_USER_PROMPT_SETUPS" ] || [ "$DOTFILES_USER_PROMPT_SETUPS" = "NO" ]; then
    exit 0
fi

if [ ! -f $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    pw "zsh-autosuggestions not found. Run 'setup_autosuggestions' to install it."
fi
