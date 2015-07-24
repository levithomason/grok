# initialize boot2docker environment if it exists
if type boot2docker > /dev/null 2>&1; then
    eval `boot2docker shellinit 2>/dev/null`
fi
