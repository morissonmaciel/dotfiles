#!/bin/bash

rm -rf ~/.zshrc
ln -s ~/.dotfiles/.zshrc ~/.zshrc

rm -rf ~/.gitconfig
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig

rm -rf ~/.p10k.zsh
ln -s ~/.dotfiles/.p10k.zsh ~/.p10k.zsh

touch ~/.hushlogin
