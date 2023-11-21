#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage: bash ${0}

apt-get update && apt-install-and-clear -y --no-install-recommends \
  curl \
  git \
  vim

HOME="${HOME:-"/root"}"

mkdir -p "${HOME}"/.vim/autoload "${HOME}"/.vim/bundle &&
  curl -sSL https://tpo.pe/pathogen.vim -o "${HOME}"/.vim/autoload/pathogen.vim

git clone https://github.com/preservim/nerdtree.git "${HOME}"/.vim/bundle/nerdtree
