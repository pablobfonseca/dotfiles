# Human readable copy
alias cp="rsync --archive --human-readable --progress --verbose --whole-file"
alias scp="rsync --archive --checksum --compress --human-readable --itemize-changes --rsh=ssh --stats --verbose"

alias pat="pygmentize -g"
alias cleanvim="vim -N -u NONE"
alias zshconfig='vim ~/.zshrc'
alias vimconfig='vim ~/.vimrc'
alias reload!='source ~/.zshrc'
alias e='$EDITOR'
alias pubkey="cat ~/.ssh/id_rsa.pub | pbcopy | echo \"Public key copied to clipboard\""
alias update="brew update"
alias upgrade="brew upgrade && brew cleanup"
alias install="brew install"
alias cinstall="brew cask install"
alias doctor="brew doctor"
alias cleanup="brew cleanup"
alias weather="curl -4 http://wttr.in/"
alias c="clear"
alias aliases="vim ~/dotfiles/zsh/config/aliases.zsh"
alias vssh="vagrant ssh"
alias vh="vagrant halt"
alias :q="exit"
alias firefox="open -a Firefox"
alias chrome="open -a Google\ Chrome.app"
alias server="bin/rails server"
alias enote="open -a Evernote"
alias skim="open -a Skim"
alias vlc="open -a VLC"
alias github="chrome http://github.com"
alias em="mutt"
alias dbox="cd ~/Dropbox"
alias prettyjson='python -m json.tool'
alias laliases="vim ~/.zsh/.aliases.local"
alias mvim="open -a MacVim.app"

source ~/.zsh/.aliases.local

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Kill all the tabs in Chrome to free up memory
# [C] explained:
# http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# IP address
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# Git aliases
alias st="git st"
alias gitlog="git log --all -p --"

# Linux
alias nocaps="/usr/bin/setxkbmap -option 'ctrl:nocaps'"
