#!/usr/bin/env bash

set -e
set -u
set -o pipefail

apt-get update && apt-install-and-clear -y --no-install-recommends \
  git \
  curl \
  zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
