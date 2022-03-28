#!/usr/bin/env bash
set -e

original_dir=$(pwd)

rm -rf ~/.nvm
git clone https://github.com/creationix/nvm.git ~/.nvm && cd $_
git checkout v0.39.1

cd ${original_dir}
unset original_dir