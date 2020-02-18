function pubkey
  cat ~/.ssh/id_rsa.pub | pbcopy | echo "Public key copied to clipboard"
end
