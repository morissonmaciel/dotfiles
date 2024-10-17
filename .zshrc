# Enable instant prompt. Should stay close to the top of $HOME/.zshrc.
if [ -f $HOME/.dotfiles/sources/source-instant-prompt.zsh ]; then
  source $HOME/.dotfiles/sources/source-instant-prompt.zsh
fi

# Main .zshrc contents
export PATH="/usr/loca/bin:$PATH"
alias ll='ls -la'
alias po='echo'
alias pe='echo'
alias pw='echo'

# Source necessary commands.sh if it exists
if [ -f $HOME/.dotfiles/scripts/commands.sh ]; then
    source $HOME/.dotfiles/scripts/commands.sh
fi

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
    po "Next time you open the terminal, the last login message will not be presented."
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
export DOTFILES_FIRST_RUN=NO
export DOTFILES_USER_PROMPT_SETUPS=YES

# Source dropin environment variables
source $HOME/.envrc

# Eveytime bootstrap script is called, it resets the DOTFILES_FIRTST_RUN variable to YES
if [ "$DOTFILES_FIRST_RUN" = "YES" ]; then
    sed -i '' 's/^DOTFILES_FIRST_RUN=.*/DOTFILES_FIRST_RUN=NO/' $HOME/.dotfiles/.envrc
    # First time setting up prompts for user adjust configurations
    DOTFILES_USER_PROMPT_SETUPS=YES
fi

# Source some scripts to the command prompt allowing configuration any time
source $HOME/.dotfiles/scripts/setup-syntax-highlighting.sh
source $HOME/.dotfiles/scripts/setup-autosuggestions.sh
source $HOME/.dotfiles/scripts/setup-powerlevel10k.sh
source $HOME/.dotfiles/scripts/setup-git.sh
source $HOME/.dotfiles/scripts/setup-github.sh
source $HOME/.dotfiles/scripts/setup-ollama.sh

if [ "$DOTFILES_FIRST_RUN" = "YES" ] && [ "$DOTFILES_USER_PROMPT_SETUPS" = "YES" ]; then
    po "First time running .dotfiles. You may be prompted to configure settings."
    po "Follow above instructions to set up as you like."
    po ""
    po "This message will be shown only one time."
    po "(To always be prompted for setups, set DOTFILES_USER_PROMPT_SETUPS to YES in .envrc)"
fi
