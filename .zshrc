# Enable instant prompt. Should stay close to the top of $HOME/.zshrc.
if [ -f $HOME/.dotfiles/pl-10k-instant-prompt.zsh ]; then
  source $HOME/.dotfiles/pl-10k-instant-prompt.zsh
fi

# Main .zshrc contents
export PATH="/usr/loca/bin:$PATH"
alias ll='ls -la'

# Set the command prompt to show the current directory in green
export PS1='%B%F{green}%1~%f ❯%b '

# Uncomment the following line to show the right side folder path
# export RPROMPT='%F{gray}%~%f'

# Source commands from ask-ollama.zshrc if it exists
if [ -f $HOME/.dotfiles/ask-ollama.zshrc ]; then
    source $HOME/.dotfiles/ask-ollama.zshrc
fi

# Apply syntax highlighting to the command prompt
setup_highlighting() {
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting
    source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
}

if [ -f $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    echo "zsh-syntax-highlighting not found. Run 'setup_highlighting' to install it."
fi

# Apply autosuggestions to the command prompt
setup_autosuggestions() {
    git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/zsh-autosuggestions
    source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
}

if [ -f $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
else
    echo "zsh-autosuggestions not found. Run 'setup_autosuggestions' to install it."
fi

# Apply Powerlevel10k theme to the command prompt
setup_powerlevel10k() {
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.zsh/powerlevel10k
    source $HOME/.zsh/powerlevel10k/powerlevel10k.zsh-theme
}

if [ -f $HOME/.zsh/powerlevel10k/powerlevel10k.zsh-theme ]; then
    source $HOME/.zsh/powerlevel10k/powerlevel10k.zsh-theme
else
    echo "Powerlevel10k not found. Run 'setup_powerlevel10k' to install it."
fi

# To customize prompt, run `p10k configure`.
if [ -f $HOME/.p10k.zsh ]; then
    source $HOME/.p10k.zsh
fi

# Disable the last login message
if [ ! -f $HOME/.hushlogin ]; then
    touch $HOME/.hushlogin
    echo "Next time you open the terminal, the last login message will not be presented."
fi

# Source commands from github configuration, if it exists
if [ -f $HOME/.dotfiles/ammends/github.zsh ]; then
    source $HOME/.dotfiles/ammends/github.zsh
fi
