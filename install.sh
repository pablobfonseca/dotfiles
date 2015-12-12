#!/bin/bash

# Install command line tools
xcode-select --install

# HomeBrew

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew install caskroom/cask/brew-cask

brew install vim tmux git node mysql postgresql

brew install zsh zsh-completions the_silver_searcher openssl redis tmate wget heroku-toolbelt

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Set ZSH as default shell
chsh -s /bin/zsh

# RVM
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
type rvm | head -n 1
rvm install ruby --latest

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

# Cask - http://caskroom.io/
brew cask install iterm2
brew cask install google-chrome
brew cask install alfred
brew cask install android-file-transfer
brew cask install caffeine
brew cask install cheatsheet
brew cask install dropbox
brew cask install google-drive
brew cask install google-hangouts
brew cask install onepassword
brew cask install spectacle
brew cask install qlmarkdown
brew cask install quicklook-json
brew cask install slack
brew cask install screenhero
brew cask install skype
brew cask install spotify

# Clean up
brew cleanup
brew cask cleanup

# NeoBundle
cd
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > install.sh
sh ./install.sh
rm install.sh

vim +NeoBundleInstall
