# Enable instant prompt. Should stay close to the top of $HOME/.zshrc.
if [ -f $HOME/.dotfiles/sources/source-instant-prompt.zsh ]; then
  source $HOME/.dotfiles/sources/source-instant-prompt.zsh
fi

# Main .zshrc contents
export PATH="/usr/loca/bin:$PATH"
alias ll='ls -la'

# Source existing .zshrc backup file
if [ -f $HOME/.dotfiles/backup/.zshrc ]; then
    # If you find conflicts with the existing .zshrc file, comment the following line
    source $HOME/.dotfiles/backup/.zshrc
fi

# Set the command prompt to show the current directory in green
export PS1='%B%F{green}%1~%f ❯%b '

# Uncomment the following line to show the right side folder path
# export RPROMPT='%F{gray}%~%f'

# To customize prompt using powerlevel10k, run `p10k configure`.
if [ -f $HOME/.p10k.zsh ]; then
    source $HOME/.p10k.zsh
fi

# Disable the last login message
if [ ! -f $HOME/.hushlogin ]; then
    touch $HOME/.hushlogin
    echo "Next time you open the terminal, the last login message will not be presented."
fi

# Check fot syntax highlighting and apply it to the command prompt
if [ -f $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Check for autosuggestions and apply it to the command prompt
if [ -f $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Check for powerlevel10k and apply it to the command prompt
if [ -f $HOME/.zsh/powerlevel10k/powerlevel10k.zsh-theme ]; then
    source $HOME/.zsh/powerlevel10k/powerlevel10k.zsh-theme
fi

# Check for ollama and apply it to the command prompt
# if [ -f $HOME/.dotfiles/ammends/ask-ollama.zshrc ]; then
#     source $HOME/.dotfiles/ammends/ask-ollama.zshrc
# fi

# Source some scripts to the command prompt allowing configuration any time
source $HOME/.dotfiles/scripts/setup-syntax-highlighting.sh
source $HOME/.dotfiles/scripts/setup-autosuggestions.sh
source $HOME/.dotfiles/scripts/setup-powerlevel10k.sh
source $HOME/.dotfiles/scripts/setup-git.sh
source $HOME/.dotfiles/scripts/setup-github.sh
source $HOME/.dotfiles/scripts/setup-ollama.sh
