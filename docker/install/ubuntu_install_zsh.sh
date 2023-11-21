#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage: bash ${0}

apt-get update && apt-install-and-clear -y --no-install-recommends \
  curl \
  git \
  zsh

HOME="${HOME:-"/root"}"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-"${HOME}"/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-"${HOME}"/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
