# Add all ssh keys matching `identity` to the ssh agent
#
# example:
# ~/.ssh/identity.github.levithomason

for key in $(ls ~/.ssh/ | grep identity | grep -v pub); do
  ssh-add ~/.ssh/$key;
done
