#!/bin/bash

answer_is_yes() {
  [[ "$REPLY" =~ ^[Yy]$ ]] \
    && return 0 \
    || return 1
}

ask() {
  print_question "$1"
  read
}

ask_for_confirmation() {
  print_question "$1 (y/n)"
  read -n 1
  printf "\n"
}

ask_for_sudo() {
  sudo -v
  # Update existent `sudo` timestamp until this script has finished
  while true; do
    sudo -n true
    sleep 60
    kill -o "$$" || exit
  done &> /dev/null &
}

cmd_exists() {
  [ -c "$(command -v "$1")" ] \
    && printf 0 \
    || printf 1
}

execute() {
  $1 &> /dev/null
  print_result $? "${2:-$1}"
}

get_answer() {
  printf "$REPLY"
}

get_os() {
  declare -r OS_NAME="$(uname -s)"
  local os=""

  if [ "$OS_NAME" == "Darwin" ]; then
    os="osx"
  elif [ "$OS_NAME" == "Linux" ] && [ -e "/etc/lsb-release" ]; then
    os="ubuntu"
  fi

  printf "%s" "$os"
}

is_git_repository() {
  [ "$(git rev-parse &>/dev/null; printf $?)" -eq 0 ] \
    && return 0 \
    || return 1
}

mkd() {
  if [ -n "$1" ]; then
    if [ -e "$1" ]; then
      if [ ! -d "$1" ]; then
        print_error "$1 - a file with the same name already exists!"
      else
        print_success "$1"
      fi
    else
      execute "mkdir -p $1" "$1"
    fi
  fi
}

print_error() {
  printf "\e[0;31m  [✖] $1 $2\e[0m\n" "]]"
}

print_info() {
  printf "\n\e[0;35m $1\e[0m\n\n" "]]"
}

print_question() {
  # Print output in yellow
  printf "\e[0;33m  [?] $1\e[0m"
}

print_result() {
  [ $1 -eq 0 ] \
    && print_success "$2" \
    || print_error "$2"

  [ "$3" == "true" ] && [ $1 -ne 0 ] \
    && exit
}

print_success() {
  # Print output in green
  printf "\e[0;32m  [✔] $1\e[0m\n"
}

# Warn user this script will overwrite current dotfiles
while true; do
  read -p "Warning: this will overwrite your current dotfiles. Continue? [y/n]"
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit;;
    *) echo "Please answer yes or no.";;
  esac
done

# Get the dotfiles directory's absolute path
SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd -P)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

dir=~/dotfiles
dir_backup=~/dotfiles_old

# Get current dir (so run this script from anywhere)
export DOTFILES_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create dotfiles_old in homedir
echo -n "Creating $dir_backup for backup of any existing dotfiles in ~..."
mkdir -p $dir_backup
echo "done"

# Change to the dotfiles directory
echo -n "Changing to the $dir directory..."
cd $dir
echo "done"

# Actual symlink stuff
echo -n "Copyng vim settings..."
mv -f ~/.vim ~/dotfiles_old
ln -s $HOME/dotfiles/vim ~/.vim
echo "done"

declare -a FILES_TO_SYMLINK=(
'ruby/gemrc'
'ruby/irbrc'
'ruby/railsrc'
'ruby/rspec'
'ruby/rvmrc'

'zsh'
'zsh/zshrc'

'shell/curlrc'

'git/gitconfig'
'git/gitignore'
'git/gitmessage'
)

for i in ${FILES_TO_SYMLINK[@]}; do
  echo "Moving any existent dotfiles from ~ to $dir_backup"
  mv ~/.${i##*/} ~/dotfiles_old
done

main() {
  local i=''
  local sourceFile=''
  local targetFile=''

  for i in ${FILES_TO_SYMLINK[@]}; do
    sourceFile="$(pwd)/$i"
    targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

    if [ ! -e "$targetFile" ]; then
      execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
    elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
      print_success "$targetFile → $sourceFile"
    else
      ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
      if answer_is_yes; then
        rm -rf "$targetFile"
        execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
      else
        print_error "$targetFile → $sourceFile"
      fi
    fi
  done

  unset FILES_TO_SYMLINK

  # Copy binaries
  ln -fs $HOME/dotfiles/bin $HOME

  declare -a BINARIES=(
  'align'
  'bundler-search'
  'gifify'
  'git-bstats'
  'git-churn'
  'git-cm'
  'git-cpr'
  'git-current-sha'
  'git-delete-merged-branches'
  'git-gpr'
  'git-nb'
  'git-pr'
  'git-pub'
  'git-publish'
  'git-shalector'
  'git-uncommit'
  'imgcat'
  'issues'
  'keychain-password'
  'mailsync'
  'notes'
  'open-tab'
  'popcaptureemail'
  'reload-chrome'
  'repos'
  'run-gist'
  'servit'
  'tagwatch'
  'tat'
  'vim-gif'
  'vlc-seek-to'
  )

  for i in ${BINARIES[@]}; do
    echo "Changing access permissions for binary script :: ${i##*/}"
    chmod +rwx $HOME/bin/${i##*/}
  done

  unset BINARIES
}


install_zsh () {
  # Check if zshell is installed. If it is:
  if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Install Oh My Zsh if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
      chsh -s $(which zsh)
    fi
  else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
      if [[ -f /etc/redhat-release ]]; then
        sudo yum install zsh
        install_zsh
      fi
      if [[ -f /etc/debian_version ]]; then
        sudo apt-get install zsh
        install_zsh
      fi
      # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
      echo "We'll install zsh, then re-run this script!"
      brew install zsh
      exit
    fi
  fi
}

# Package managers & packages
install_package_managers() {
  ./"$DOTFILES_DIR/install/brew.sh"
  ./"$DOTFILES_DIR"/install/npm.sh

  if [ "$(uname)" == "Darwin" ]; then
    ./"$DOTFILES_DIR/install/brew_cask.sh"
  fi

  brew bundle
}

main
install_zsh
install_package_managers

source ~/.zshrc
