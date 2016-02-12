# initialize default docker environment if it exists
if type docker-machine > /dev/null 2>&1; then
  docker-machine start default
  eval `docker-machine env default 2> /dev/null`
fi
