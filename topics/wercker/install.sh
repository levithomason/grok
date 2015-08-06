#!/bin/sh
#
# Wercker CLI
#
# This CLI is not available on brew so we have to grab it manually

echo "... downloading latest stable wercker cli"
curl -sL https://s3.amazonaws.com/downloads.wercker.com/cli/stable/darwin_amd64/wercker -o $GROK_BIN/wercker
chmod +x $GROK_BIN/wercker
wercker version
