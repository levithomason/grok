# start default docker and init env
docker-init() {
  if type docker-machine > /dev/null 2>&1; then
    echo "... starting default docker machine"
    docker-machine start default > /dev/null 2>&1

    echo "... eval docker env"
    eval `docker-machine env default 2> /dev/null`
  else
    echo "Looks like you don't have docker-machine installed"
  fi
}
