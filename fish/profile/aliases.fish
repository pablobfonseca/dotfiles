# Check more at: https://github.com/nicksp/dotfiles/blob/master/shell/shell_aliases
#

# IP address
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
alias modemip="netstat -rn | grep default"
alias ls="ls -lGa"

# Git aliases
alias st="git st"
alias gitlog="git log --all -p --"
alias bs="git bselect"

# Linux
alias nocaps="/usr/bin/setxkbmap -option 'ctrl:nocaps'"

# EHV Prod
alias ehvprod="cx ssh -s 'ehv-stage' -e production Jaguar"

alias mux="tmuxinator"
