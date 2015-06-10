###############################################################################
# RUN TOPIC ZSH FILES
#
# In this order:
#
# 1) path.zsh
# 2) *.zsh (except 1 & 3)
# 3) completion.zsh

echo 'GROK: run_topic_zsh_files'

#
# Unique array of all `*.zsh` files
#

typeset -U config_files
config_files=($DOTFILES_TOPICS/**/*.zsh)


#
# path.zsh
#

echo '... running /topics/**/path.zsh'
for file in ${(M)config_files:#*/path.zsh}; do
  source $file
done


#
# *.zsh
# (except path and completion)
#

echo '... running /topics/**/*.zsh'
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}; do
  source $file
done


#
# completion.zsh
#

echo '... running /topics/**/completion.zsh'
# load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}; do
  source $file
done


#
# Cleanup
#

unset config_files
