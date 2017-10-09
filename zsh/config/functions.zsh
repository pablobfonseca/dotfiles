# vim: syntax=sh

function vimup { vim +PlugUpdate }

function git-new-remote-tracking {
  git checkout -b $1 && git push -u origin $1
}

function git_branch_name {
  echo $(git branch 2>/dev/null | grep '^*' | colrm 1 2)
}

function git-nuke {
  git branch -D $1 && git push origin :$1
}
compdef _git git-nuke=git-checkout

function git-on-master {
  branch=`git_branch_name`
  git checkout master && git pull --rebase 
  git checkout $branch
  git rebase master
}

# Search for an especific route on rails
# Usage:
# search_route users
function search_route {
  bin/rake routes | ag $1
}

# Create and enter in a folder
# Usage:
# take teste
function take {
  mkdir $1
  cd $1
}

function bundle_search() {
  pattern="$1"; shift
  ag $pattern $(bundle show --paths "$@")
}

function branch_clean() {
  git branch --merged | egrep -v "(^\*|master)" | xargs git branch -d
}

function branch_remote_clean() {
  git branch -r --merged origin/master \
    | awk -F/ '/^\s*origin/ {if (!match($0, /origin\/master/)) {sub("^\\s*origin/", ""); print}}' \
    | xargs -rpn1 git push origin --delete
}

function generate_password() {
  openssl rand -hex 8
}

freethousand() {
  port="${1:-3000}"
  pid="$(lsof -Fp -i tcp:$port | sed 's/p//')"

  if [ -n "$pid" ]; then
    echo "Killing process with PID $pid listening on port $port..." >&2
    kill $pid
  else
    echo "No process listening on port $port" >&2
  fi
}

function server() {
  local port="${1:-8000}"
  open "http://localhost:${port}"
  # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
  # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
  python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"

}

rvmlist() {
  local rb
  rb=$((echo system; rvm list | grep ruby | cut -c 4-) |
  awk '{print $1}' |
  fzf-tmux -l 30 +m --reverse) && rvm use $rb
}
