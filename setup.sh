#!/bin/bash

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
fi

{
    echo "export PATH=\"/usr/local/bin:$PATH\""
    echo "source ~/.dotfiles/.zshrc"
    echo ""
    echo "# Load previous ${current_zshrc} zshrc"
    echo "if [ -f ~/.dotfiles/${current_zshrc}.zshrc ]; then"
    echo "    source ~/.dotfiles/${current_zshrc}.zshrc"
    echo "fi"
} >> "$HOME/.zshrc"
