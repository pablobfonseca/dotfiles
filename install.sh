#!/bin/bash

# Install HomeBrew

ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

# Update brew
brew update

# Install vim, tmux, git, node, mysql and postgresql
brew install vim tmux git node mysql postgresql

# Other tools
brew install mongodb zsh the_silver_searcher openssl redis tmate wget

# Cask - http://caskroom.io/
brew install caskroom/cask/brew-cask

# Vagrant
brew cask install virtualbox
brew cask install vagrant-exec

# Vim and Tmux
ln -s .dotfiles/vim/vimrc ~/.vimrc
ln -s .dotfiles/tmux ~/.tmux && ln -s .dotfiles/tmux/tmux.conf ~/.tmux.conf

vim +NeoBundleInstall
