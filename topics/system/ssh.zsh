# Add all ssh keys matching `identity` to the ssh agent
#
# example:
# ~/.ssh/identity.github.levithomason

# start agent if not already running
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  eval `ssh-agent -s` > /dev/null 2>&1
fi

# remove all keys first
ssh-add -D > /dev/null 2>&1

# add all keys
for key in $(ls ~/.ssh/ | grep identity | grep -v \.pub$); do
  # 600 disallow access by others, required so their not ignored
  chmod 600 ~/.ssh/$key
  ssh-add ~/.ssh/$key > /dev/null 2>&1
done
