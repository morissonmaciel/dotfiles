#.zshrc
alias ll='ls -la'

# Set the command prompt to show the current directory in green
export PS1='%B%F{green}%1~%f ❯%b '

# Uncomment the following line to show the right side folder path
# export RPROMPT='%F{gray}%~%f'

# Source commands from ask-ollama.zshrc if it exists
if [ -f ~/.dotfiles/ask-ollama.zshrc ]; then
    source ~/.dotfiles/ask-ollama.zshrc
fi
