#!/bin/bash

clear && clear
echo -e "\033[1;34mThis script will configure .dotfiles for the current user folder and apply changes to the zsh shell.\033[0m"
read -p $'\033[1;33mIs it okay to proceed? (Y/n): \033[0m' proceed
proceed=${proceed:-Y}

if ! [[ "$proceed" =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 1
fi

if [ ! -d "$HOME/.dotfiles" ]; then
    mkdir "$HOME/.dotfiles"
fi

if [[ "$1" == "--web" ]]; then
    curl -L -o "$HOME/.dotfiles/.zshrc" https://raw.githubusercontent.com/morissonmaciel/Dotfiles/main/.zshrc
    curl -L -o "$HOME/.dotfiles/ask-ollama.zshrc" https://raw.githubusercontent.com/morissonmaciel/Dotfiles/main/ask-ollama.zshrc
else
    for file in "$PWD"/*.zshrc; do
        if [ -f "$file" ]; then
            cp "$file" "$HOME/.dotfiles/"
        fi
    done
fi

if [ -f "$HOME/.zshrc" ]; then
    read -p "Enter the name of your current .zshrc backup (default: user-original): " current_zshrc

    current_zshrc=${current_zshrc:-user-original}
    cp "$HOME/.zshrc" "$HOME/.dotfiles/${current_zshrc}.zshrc"

    rm -rf "$HOME/.zshrc"
fi

{
    echo 'export PATH="/usr/local/bin:$PATH"'
    echo "source ~/.dotfiles/.zshrc"
    echo ""
    echo "# Load previous ${current_zshrc} zshrc"
    echo "if [ -f ~/.dotfiles/${current_zshrc}.zshrc ]; then"
    echo "    source ~/.dotfiles/${current_zshrc}.zshrc"
    echo "fi"
} >> "$HOME/.zshrc"

echo -e "\033[1;32mConfiguration complete! Your .dotfiles have been set up and changes applied to the zsh shell.\033[0m"
