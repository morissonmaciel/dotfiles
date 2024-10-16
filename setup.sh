#!/bin/bash

if [ ! -d "$HOME/.dotfiles" ]; then
    mkdir "$HOME/.dotfiles"
fi

for file in "$PWD"/*.zshrc; do
    if [ -f "$file" ]; then
        cp "$file" "$HOME/.dotfiles/"
    fi
done

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
