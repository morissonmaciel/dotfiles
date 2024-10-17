#!/bin/bash

clear && clear
echo "\033[1;34mThis script will configure .dotfiles for the current user folder and apply changes to the zsh shell.\033[0m"
read -p $'\033[1;33mIs it okay to proceed? (Y/n): \033[0m' proceed
proceed=${proceed:-Y}

if ! [[ "$proceed" =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 1
fi

#
# Cleaning up previous installation for .dotfiles
#

if [ -f "$HOME/.dotfiles/backup/.zshrc" ]; then
    read -p $'\033[1;33mA backup .zshrc file was found. Do you want to restore it? (Y/n): \033[0m' restore_zshrc
    restore_zshrc=${restore_zshrc:-Y}

    if [[ "$restore_zshrc" =~ ^[Yy]$ ]]; then
        cp "$HOME/.dotfiles/backup/.zshrc" "$HOME/.zshrc"
        echo "\033[1;32mBackup .zshrc restored.\033[0m"
    fi
fi

if [ -f "$HOME/.dotfiles/backup/.envrc" ]; then
    read -p $'\033[1;33mA backup .envrc file was found. Do you want to restore it? (Y/n): \033[0m' restore_envrc
    restore_envrc=${restore_envrc:-Y}

    if [[ "$restore_envrc" =~ ^[Yy]$ ]]; then
        cp "$HOME/.dotfiles/backup/.envrc" "$HOME/.envrc"
        echo "\033[1;32mBackup .envrc restored.\033[0m"
    fi
fi

if [ -f "$HOME/.dotfiles/backup/.gitconfig" ]; then
    read -p $'\033[1;33mA backup .gitconfig file was found. Do you want to restore it? (Y/n): \033[0m' restore_gitconfig
    restore_gitconfig=${restore_gitconfig:-Y}

    if [[ "$restore_gitconfig" =~ ^[Yy]$ ]]; then
        cp "$HOME/.dotfiles/backup/.gitconfig" "$HOME/.gitconfig"
        echo "\033[1;32mBackup .gitconfig restored.\033[0m"
    fi
fi

#
# Purge existing .dotfiles folder
#

echo "\033[1;33mCleaning up previous .dotfiles installation...\033[0m"
if [ -d "$HOME/.dotfiles" ]; then
    rm -rf "$HOME/.dotfiles"
fi

echo "\033[1;32mCreating new .dotfiles installation folder.\033[0m"
mkdir "$HOME/.dotfiles"
mkdir "$HOME/.dotfiles/sources"
mkdir "$HOME/.dotfiles/scripts"

#
# Backup existing .zshrc and .gitconfig files
#

if [ -f "$HOME/.zshrc" ]; then
    mkdir -p "$HOME/.dotfiles/backup"
    cp "$HOME/.zshrc" "$HOME/.dotfiles/backup/.zshrc"
    echo "\033[1;32mCurrent .zshrc has been backed up to $HOME/.dotfiles/backup/.\033[0m"
fi

if [ -f "$HOME/.envrc" ]; then
    mkdir -p "$HOME/.dotfiles/backup"
    cp "$HOME/.envrc" "$HOME/.dotfiles/backup/.envrc"
    echo "\033[1;32mCurrent .envrc has been backed up to $HOME/.dotfiles/backup/.\033[0m"
fi

if [ -f "$HOME/.gitconfig" ]; then
    mkdir -p "$HOME/.dotfiles/backup"
    cp "$HOME/.gitconfig" "$HOME/.dotfiles/backup/.gitconfig"
    echo "\033[1;32mCurrent .gitconfig has been backed up to $HOME/.dotfiles/backup/.\033[0m"
fi

#
# Web installing .dotfiles, scripts and source files
#

if [[ "$1" == "--web" ]]; then
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

else
    echo "This setup is intended for web installation only. Please use the --web flag."
    exit 1
fi

#
# Bootstrap .dotfiles configuration
#

cd "$HOME/.dotfiles"
bash bootstrap.sh

# Final message
echo "\033[1;32mConfiguration complete! Your .dotfiles have been set up and changes applied to the zsh shell.\033[0m"
echo "\033[1;33mPlease close and re-open your terminal to apply the changes.\033[0m"
