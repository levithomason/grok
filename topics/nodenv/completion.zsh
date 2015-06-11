# todo: this doesn't actually enable autocomplete...?

echo "... enable nodenv autocomplete"
if which nodenv > /dev/null; then 
  eval "$(nodenv init -)";
fi
