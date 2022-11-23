# Setting PATH for Python 3.8
# The original version is saved in .zprofile.pysave
# export PATH="/Library/Frameworks/Python.framework/Versions/3.8/bin:${PATH}"

export PATH="/Users/levithomason/Library/Python/3.9/bin:$PATH"
export VIRTUAL_ENV="/Users/levithomason/src/"

# https://github.com/psycopg/psycopg2/issues/1200#issuecomment-934861409
# Supposedly fixes yieldnodes_legal error on sign in:
# ImportError: dlopen(/Users/levithomason/src/venv_yieldnodes_legal/lib/python3.8/site-packages/psycopg2/_psycopg.cpython-38-darwin.so, 0x0002): symbol not found in flat namespace '_PQbackendPID'
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
