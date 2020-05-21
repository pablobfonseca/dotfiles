function bip --description "Install brew plugins"
  set -l inst (brew search | eval "fzf --height=40% -m --header='[brew:install]'")

  if not test (count $inst) = 0
    for prog in $inst
      brew install "$prog"
    end
  end
end
