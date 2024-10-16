#.zshrc
alias ll='ls -la'

# Set the command prompt to show the current directory in green
export PS1='%B%F{green}%1~%f ❯%b '
# Uncomment the following line to show the right side folder path
# export RPROMPT='%F{gray}%~%f'

# Source commands from llm-ask.zsh if it exists
if [ -f ~/.dotfiles/llm-ask.zsh ]; then
    source ~/.dotfiles/llm-ask.zsh
fi
