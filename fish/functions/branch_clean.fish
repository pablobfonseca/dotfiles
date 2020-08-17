function branch_clean
  git for-each-ref --format '%(refname:short) %(upstream:track)' |
    awk '$2 == "[gone]" {print $1}' | xargs git branch -D
end
