{{REWRITTEN_CODE}}
#!/bin/bash

echo "This script will configure .dotfiles for the current user folder and apply changes to the zsh shell."
read -p "Is it okay to proceed? (Y/n): " proceed
proceed=${proceed:-Y}

if [[ "$proceed" =~ ^[Yy]$ ]]; then
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
else
    echo "Operation cancelled."
fi
{{REWRITTEN_CODE}}
