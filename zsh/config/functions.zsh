# vim: syntax=sh

function vimup { vim +PlugUpdate }

function git-new-remote-tracking {
  git checkout -b $1 && git push -u origin $1
}

function git_branch_name {
  val=`git branch 2>/dev/null | grep '^*' | colrm 1 2`
  echo "$val"
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
