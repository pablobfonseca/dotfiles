# Check more at: https://github.com/nicksp/dotfiles/blob/master/shell/shell_aliases
#
# Human readable copy
alias cp="rsync --archive --human-readable --progress --verbose --whole-file"
alias scp="rsync --archive --progress --checksum --compress --human-readable --itemize-changes --rsh=ssh --stats --verbose"

alias vim="nvim"
alias vi="nvim"
alias path="echo $PATH | tr -s ':' '\n'"
alias pat="pygmentize -O style=monokad -f console256 -g"
alias cleanvim="vim -N -u NONE"
alias zshconfig='vim ~/.zshrc'
alias fishconfig='vim ~/.config/fish/config.fish'
alias vimconfig='vim ~/.vimrc'
alias reload!='source ~/.zshrc'
alias pubkey="cat ~/.ssh/id_rsa.pub | pbcopy | echo \"Public key copied to clipboard\""
alias update="brew update"
alias upgrade="brew upgrade && brew cleanup"
alias install="brew install"
alias cinstall="brew cask install"
alias doctor="brew doctor"
alias weather="curl -4 http://wttr.in/"
alias aliases="vim ~/.dotfiles/zsh/config/aliases.zsh"
alias :q="exit"
alias em="mutt"
alias prettyjson='python -m json.tool'
alias laliases="vim ~/.zsh/.aliases.local"
alias mvim="open -a MacVim.app"
alias e="vim"
alias startredis="redis-server /usr/local/etc/redis.conf"
alias railscs="rails c -s"
alias hp='heroku accounts:set personal'
alias hw='heroku accounts:set work'
alias lg='lazygit'
alias cleanelastic="curl -XPUT -H \"Content-Type: application/json\" http://localhost:9200/_all/_settings -d '{\"index.blocks.read_only_allow_delete\": null}'"
alias cat="bat"
alias code="cd ~/code"
alias ems="emacs --daemon"
alias emc="emacsclient -n -c"
alias fvim="fzf | xargs nvim"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Kill all the tabs in Chrome to free up memory
# [C] explained:
# http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# IP address
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
alias modemip="netstat -rn | grep default"

# Git aliases
alias st="git st"
alias gitlog="git log --all -p --"
alias bselect="git bselect"

# Check port 3000
alias check3000='lsof -i :3000'

# Linux
alias nocaps="/usr/bin/setxkbmap -option 'ctrl:nocaps'"

# EHV Prod
alias ehvprod="cx ssh -s 'ehv-stage' -e production Jaguar"

alias mux="tmuxinator"
