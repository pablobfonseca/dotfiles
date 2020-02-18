function check_port
  lsof -i ":$argv"
end
