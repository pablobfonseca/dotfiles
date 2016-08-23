function docker_ip {
  docker-machine ip bziineo | pbcopy
  echo "Machine ip copied!"
}
