# Add all ssh keys matching `identity` to the ssh agent
#
# example:
# ~/.ssh/identity.github.levithomason

echo "... adding ~/.ssh identities"

# start agent
eval `ssh-agent -s`

# add all keys
for key in $(ls ~/.ssh/ | grep identity | grep -v \.pub$); do
  ssh-add ~/.ssh/$key > /dev/null 2>&1
done
