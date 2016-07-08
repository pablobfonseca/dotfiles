# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# allow autocomplete using up/down arrows
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
