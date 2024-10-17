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
if [ -f $HOME/.dotfiles/sources/source-ollama.zsh ]; then
    source $HOME/.dotfiles/sources/source-ollama.zsh
fi

# Check for copilot and apply it to the command prompt
if [ -f $HOME/.dotfiles/sources/source-copilot.zsh ]; then
    source $HOME/.dotfiles/sources/source-copilot.zsh
fi

# Setting up environment variables for .dotfiles
export DOTFILES_FIRTST_RUN=false
export DOTFILES_USER_PROMPT_SETUPS=false

# Source dropin environment variables
source $HOME/.envrc

if [ $DOTFILES_FIRTST_RUN = true ]; then
    sed -i 's/^DOTFILES_FIRTST_RUN=.*/DOTFILES_FIRTST_RUN=false/' $HOME/.envrc
    # First time setting up prompts for user adjust configurations
    DOTFILES_USER_PROMPT_SETUPS=true
fi

# Source some scripts to the command prompt allowing configuration any time
source $HOME/.dotfiles/scripts/setup-syntax-highlighting.sh
source $HOME/.dotfiles/scripts/setup-autosuggestions.sh
source $HOME/.dotfiles/scripts/setup-powerlevel10k.sh
source $HOME/.dotfiles/scripts/setup-git.sh
source $HOME/.dotfiles/scripts/setup-github.sh
source $HOME/.dotfiles/scripts/setup-ollama.sh

if [ $DOTFILES_USER_PROMPT_SETUPS = true ] && [ $DOTFILES_FIRTST_RUN = true ]; then
    echo "Since it's the first time you are running the .dotfiles, you may be prompted to configure some settings."
    echo "Please, follow the instructions and configure the settings as you wish."
    echo ""
    echo "If you want to always be prompted to configure the settings, set the DOTFILES_USER_PROMPT_SETUPS variable to true in the .envrc file."
fi
