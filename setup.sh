#!/bin/bash

clear && clear

if [[ "$1" != "--web" ]]; then
    echo "This setup is intended for web installation only. Please use the --web flag."
    exit 1
fi

echo "This script will configure .dotfiles for the current user folder and apply changes to the zsh shell."
read -p "Is it okay to proceed? (Y/n): " proceed
proceed=${proceed:-Y}

if ! [[ "$proceed" =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 1
fi

#
# Cleaning up previous installation for .dotfiles
#

if [ -f "$HOME/.dotfiles/backup/.zshrc" ]; then
    read -p "A backup .zshrc file was found. Do you want to restore it? (Y/n): " restore_zshrc
    restore_zshrc=${restore_zshrc:-Y}

    if [[ "$restore_zshrc" =~ ^[Yy]$ ]]; then
        cp "$HOME/.dotfiles/backup/.zshrc" "$HOME/.zshrc"
        echo "Backup .zshrc restored."
    fi
fi

if [ -f "$HOME/.dotfiles/backup/.envrc" ]; then
    read -p "A backup .envrc file was found. Do you want to restore it? (Y/n): " restore_envrc
    restore_envrc=${restore_envrc:-Y}

    if [[ "$restore_envrc" =~ ^[Yy]$ ]]; then
        cp "$HOME/.dotfiles/backup/.envrc" "$HOME/.envrc"
        echo "Backup .envrc restored."
    fi
fi

if [ -f "$HOME/.dotfiles/backup/.gitconfig" ]; then
    read -p "A backup .gitconfig file was found. Do you want to restore it? (Y/n): " restore_gitconfig
    restore_gitconfig=${restore_gitconfig:-Y}

    if [[ "$restore_gitconfig" =~ ^[Yy]$ ]]; then
        cp "$HOME/.dotfiles/backup/.gitconfig" "$HOME/.gitconfig"
        echo "Backup .gitconfig restored."
    fi
fi

#
# Purge existing .dotfiles folder
#

echo "Cleaning up previous .dotfiles installation..."
if [ -d "$HOME/.dotfiles" ]; then
    rm -rf "$HOME/.dotfiles"
fi

echo "Creating new .dotfiles installation folder."
mkdir "$HOME/.dotfiles"
mkdir "$HOME/.dotfiles/sources"
mkdir "$HOME/.dotfiles/scripts"

#
# Backup existing .zshrc and .gitconfig files
#

if [ -f "$HOME/.zshrc" ]; then
    mkdir -p "$HOME/.dotfiles/backup"
    cp "$HOME/.zshrc" "$HOME/.dotfiles/backup/.zshrc"
    echo "Current .zshrc has been backed up to $HOME/.dotfiles/backup/."
fi

if [ -f "$HOME/.envrc" ]; then
    mkdir -p "$HOME/.dotfiles/backup"
    cp "$HOME/.envrc" "$HOME/.dotfiles/backup/.envrc"
    echo "Current .envrc has been backed up to $HOME/.dotfiles/backup/."
fi

if [ -f "$HOME/.gitconfig" ]; then
    mkdir -p "$HOME/.dotfiles/backup"
    cp "$HOME/.gitconfig" "$HOME/.dotfiles/backup/.gitconfig"
    echo "Current .gitconfig has been backed up to $HOME/.dotfiles/backup/."
fi

#
# Web installing .dotfiles, scripts and source files
#

curl -L -o "$HOME/.dotfiles/bootstrap.sh" \
    https://raw.githubusercontent.com/morissonmaciel/dotfiles/main/bootstrap.sh

# Download main files
main_files=(
    ".zshrc"
    ".envrc"
    ".p10k.zsh"
    ".gitconfig"
)

for file in "${main_files[@]}"; do
    curl -L -o "$HOME/.dotfiles/$file" \
        "https://raw.githubusercontent.com/morissonmaciel/dotfiles/main/$file"
done

# Download source files
sources=(
    "source-instant-prompt.zsh"
    "source-ollama.zsh"
    "source-copilot.zsh"
)

for source in "${sources[@]}"; do
    curl -L -o "$HOME/.dotfiles/sources/$source" \
        "https://raw.githubusercontent.com/morissonmaciel/dotfiles/main/sources/$source"
done

# Download scripts files
scripts=(
    "commands.sh"
    "setup-autosuggestions.sh"
    "setup-syntax-highlighting.sh"
    "setup-powerlevel10k.sh"
    "setup-git.sh"
    "setup-github.sh"
    "setup-ollama.sh"
)

for script in "${scripts[@]}"; do
    curl -L -o "$HOME/.dotfiles/scripts/$script" \
        "https://raw.githubusercontent.com/morissonmaciel/dotfiles/main/scripts/$script"
done

#
# Bootstrap .dotfiles configuration
#

cd "$HOME/.dotfiles"
bash bootstrap.sh

# Final message
echo "Configuration complete! Your .dotfiles have been set up and changes applied to the zsh shell."
echo "Please close and re-open your terminal to apply the changes."
