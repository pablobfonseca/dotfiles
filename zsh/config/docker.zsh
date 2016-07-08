function docker_ip {
  docker-machine ip $1 | pbcopy
  echo "Machine ip copied!"
}
