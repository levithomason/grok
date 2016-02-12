# initialize default docker environment if it exists
if type docker-machine > /dev/null 2>&1; then
  echo "... starting default docker machine"
  docker-machine start default > /dev/null 2>&1
  eval `docker-machine env default 2> /dev/null`
fi
