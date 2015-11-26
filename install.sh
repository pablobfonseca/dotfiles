#!/bin/bash

# Install HomeBrew

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Update brew
brew update

# Install vim, tmux, git, node, mysql and postgresql
brew install vim tmux git node mysql postgresql

# Other tools
brew install mongodb zsh the_silver_searcher openssl redis tmate wget

# Cask - http://caskroom.io/
brew install caskroom/cask/brew-cask

# Vim and Tmux
ln -s dotfiles/zsh/zshrc ~/.zshrc
source ~/.zshrc
ln -s dotfiles/vim  ~/.vim
ln -s dotfiles/vim/.vimrc ~/.vimrc
ln -s dotfiles/tmux ~/.tmux
ln -s dotfiles/tmux/tmux-conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tmux-battery ~/.tmux/plugins/tmux-battery

# Git
ln -s dotfiles/.gitconfig ~/.gitconfig

# NeoBundle
cd
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > install.sh
sh ./install.sh
rm install.sh

vim +NeoBundleInstall
