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
  echo "[6]  Configure Git"
  echo "[7]  Install brew casks"
  echo "[8]  Cleanup brew"
  echo "[9]  Install NeoBundle"
  echo "[10] Install vagrant"
  echo "[11] Install Slate"
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
    brew install vim tmux ranger git node mysql postgresql tig
    brew install zsh zsh-completions hub the_silver_searcher openssl redis tmate wget heroku-toolbelt
  elif [[ "$mc" == "3" ]]; then
    # It installs oh-my-zsh and set zsh as a default shell
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    chsh -s /bin/zsh
  elif [[ "$mc" == "4" ]]; then
    # RVM installation
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    \curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm
    type rvm | head -n 1
    # Installs the lastest ruby version
    rvm install ruby --latest
  elif [[ "$mc" == "5" ]]; then
    # Vim and Tmux
    ln -s dotfiles/zsh/zshrc ~/.zshrc
    source ~/.zshrc
    ln -s dotfiles/vim  ~/.vim
    ln -s dotfiles/vim/.vimrc ~/.vimrc
    ln -s dotfiles/tmux ~/.tmux
    ln -s dotfiles/tmux/tmux-conf ~/.tmux.conf
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    git clone https://github.com/tmux-plugins/tmux-battery ~/.tmux/plugins/tmux-battery
  elif [[ "$mc" == "6" ]]; then
    # Git
    ln -s dotfiles/.gitconfig ~/.gitconfig
  elif [[ "$mc" == "7" ]]; then
    # Cask - http://caskroom.io/
    brew cask install iterm2
    brew cask install google-chrome
    brew cask install alfred
    brew cask install android-file-transfer
    brew cask install caffeine
    brew cask install dropbox
    brew cask install google-drive
    brew cask install google-hangouts
    brew cask install qlmarkdown
    brew cask install quicklook-json
    brew cask install slack
    brew cask install screenhero
    brew cask install skype
    brew cask install spotify
  elif [[ "$mc" == "8" ]]; then
    brew cleanup
    brew cask cleanup
  elif [[ "$mc" == "9" ]]; then
    # NeoBundle
    cd
    curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > install.sh
    sh ./install.sh
    rm install.sh
    vim +NeoBundleInstall
  elif [[ "$mc" == "10" ]]; then
    brew cask install virtualbox
    brew cask install vagrant
    brew cask install vagrant-manager
  elif [[ "$mc" == "11" ]]; then
    cd /Applications
    curl http://www.ninjamonkeysoftware.com/slate/versions/slate-latest.tar.gz | tar -xz
    cd ~/dotfiles && ln -s slate ~/.slate
  fi
  showMenu
  m=$?
done
