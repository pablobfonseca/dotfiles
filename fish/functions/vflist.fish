function vflist
  set -l py (vf ls | fzf-tmux -l 30 +m --reverse)
  vf activate $py
end
