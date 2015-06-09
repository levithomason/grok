echo "... pull latest grokfiles"

grok_old_pwd=$(pwd)

cd $DOTFILES_ROOT
git pull
cd $grok_old_pwd

unset grok_old_pwd
