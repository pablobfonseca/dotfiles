#
#   __ _     _     
#  / _(_)___| |__  
# | |_| / __| '_ \ 
# |  _| \__ \ | | |
# |_| |_|___/_| |_|
                 
set -U EDITOR nvim
set -U MUSIC_APP Spotify
set -U VISUAL $EDITOR
set -U BUNDLER_EDITOR $EDITOR
set -U HOMEBREW_CASK_OPTS --appdir=/Applications
set -U DOTFILES $HOME/.dotfiles
set -U FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'
set -U FZF_DEFAULT_OPTS '--height=50% --min-height=15 --preview="bat --style=numbers --color=always {} | head -500" --preview-window=right:60%:wrap'
set -U FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -U FZF_COMPLETE 1

set -U DENO_INSTALL '/Users/pablobfonseca/.deno'

set -gx NVM_DIR $HOME/.nvm
set -U SHELL /usr/local/bin/fish 

for path in $HOME/bin /usr/local/bin /usr/bin /bin /usr/sbin /sbin
  if test -e $path; and not contains $path $PATH
    set -x PATH $PATH $path
  end
end

set -x PATH $PATH $HOME/.rvm/bin
set -x PATH $PATH /usr/local/share/npm/bin
set -x PATH $PATH bin
set -x PATH $PATH /usr/local/opt/go/libexec/bin
set -x PATH $PATH /Applications/Postgres.app/Contents/Versions/10/bin
set -x PATH $PATH /usr/local/opt/imagemagick@6/bin
set -x PATH $PATH /Users/pablobfonseca/Library/Python/3.7/bin
set -x PATH $PATH /Users/pablobfonseca/.cargo/bin
set -x PATH $PATH /Users/pablobfonseca/.cabal/bin
set -x PATH $PATH /Users/pablobfonseca/.ghcup/bin
set -x PATH $PATH /usr/local/sbin
set -x PATH $PATH $DENO_INSTALL/bin:$PATH
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

# Go
set -x GOPATH $HOME/code/go-workspace
set -x GOROOT /usr/local/opt/go/libexec
set -x GOBIN $GOPATH/bin
set -x PATH $PATH $GOROOT/bin
set -x PATH $PATH $GOPATH/bin

# Heroku toolbelt
set -x PATH $PATH /usr/local/heroku/bin

set -x MANPATH /usr/local/man


for config in ~/.config/fish/profile/*.fish
  source $config
end

bind \ce edit_command_buffer

set -g fish_user_paths "/usr/local/mysql/bin" $fish_user_paths

# Starhip Theme
starship init fish | source
# ghcup-env
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
test -f /Users/pablobfonseca/.ghcup/env ; and set -gx PATH $HOME/.cabal/bin /Users/pablobfonseca/.ghcup/bin $PATH
