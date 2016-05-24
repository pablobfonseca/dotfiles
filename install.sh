#!/bin/bash

showMenu(){
  echo "----------------"
  echo " Installation   "
  echo "----------------"
  echo "[1]  Xcode"
  echo "[2]  Homebrew"
  echo "[3]  Oh-my-zsh"
  echo "[4]  RVM"
  echo "[5]  Configure VIM/TMUX"
  echo "[6]  Install brew casks"
  echo "[7] Link symlinks"
  echo "[0]  Exit"
  echo "----------------"

  read -p "Please select an option: " mc
  return $mc

}
while [[ "$m" != "0"  ]]
do
  if [[ "$mc" == "1" ]]; then
    xcode-select --install
  elif [[ "$mc" == "2" ]]; then
    # Homebrew installation and some packages
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew update
    brew install caskroom/cask/brew-cask
    brew install vim tmux ranger git node mysql postgresql tig mutt
    brew install zsh zsh-completions hub the_silver_searcher openssl redis tmate wget heroku-toolbelt pandoc
  elif [[ "$mc" == "3" ]]; then
    # It installs oh-my-zsh and set zsh as a default shell
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    chsh -s /bin/zsh
  elif [[ "$mc" == "4" ]]; then
    # RVM installation
    \curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm
    type rvm | head -n 1
    # Installs the latest ruby version
    rvm install ruby --latest
  elif [[ "$mc" == "5" ]]; then
    # Vim and Tmux
    ln -s dotfiles/zsh/zshrc ~/.zshrc
    source ~/.zshrc
    ln -s dotfiles/vim  ~/.vim
    ln -s dotfiles/vim/.vimrc ~/.vimrc
    ln -s dotfiles/tmux ~/.tmux
    ln -s dotfiles/tmux/tmux-conf ~/.tmux.conf
    ln -s dotfiles/irbrc ~/.irbrc
    ln -s dotfiles/gemrc ~/.gemrc
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    git clone https://github.com/tmux-plugins/tmux-battery ~/.tmux/plugins/tmux-battery
  elif [[ "$mc" == "6" ]]; then
    # Cask - http://caskroom.io/
    brew cask install iterm2 google-chrome alfred android-file-transfer caffeine dropbox google-drive google-hangouts
    brew cask install qlmarkdown quicklook-json slack screenhero skype spotify
  elif [[ "$mc" == "7" ]]; then
    # Git
    ln -s dotfiles/git_template ~/.git_template
    ln -s dotfiles/git_template/gitconfig ~/.gitconfig
    # Screen
    ln -s ~/dotfiles/screenrc ~/.screenrc
    # Mutt
    ln -s ~/dotfiles/mutt ~/.mutt
    # psqlrc
    ln -s ~/dotfiles/.psqlrc ~/.psqlrc
    # Rails
    ln -s ~/dotfiles/.railsrc ~/.railsrc
  fi
  showMenu
  m=$?
done
