function emacs_start
  if not pgrep -f emacs > /dev/null
    emacs --daemon && emacsclient -c
  else
    emacsclient -c
  end
end
