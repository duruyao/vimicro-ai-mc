#!/usr/bin/env bash

set -e

COMMAND_ARGS=("${@}")

{
  useradd -ms /bin/bash -d "${THIS_BUILD_HOME}" "${THIS_BUILD_USER}"
  usermod -aG sudo "${THIS_BUILD_USER}"
  echo "${THIS_BUILD_USER}":"${THIS_BUILD_USER}" | chpasswd
  usermod -u "${THIS_BUILD_UID}" "${THIS_BUILD_USER}"
  groupmod -g "${THIS_BUILD_GID}" "${THIS_BUILD_GROUP}"

  if [ -n "$(command -v zsh)" ]; then
    chsh -s "$(which zsh)" "${THIS_BUILD_USER}"
  fi

  cp -rf /root/.vim "${THIS_BUILD_HOME}"/.vim || true
  cp -rf /root/.vimrc "${THIS_BUILD_HOME}"/.vimrc || true
  cp -rf /root/.bashrc "${THIS_BUILD_HOME}"/.bashrc || true
  cp -rf /root/.zshrc "${THIS_BUILD_HOME}"/.zshrc || true
  cp -rf /root/.zprofile "${THIS_BUILD_HOME}"/.zprofile || true
  cp -rf /root/.oh-my-zsh "${THIS_BUILD_HOME}"/.oh-my-zsh || true
  cp -rf /root/.tmux.conf "${THIS_BUILD_HOME}"/.tmux.conf || true

  chown -R "${THIS_BUILD_USER}":"${THIS_BUILD_USER}" "${THIS_BUILD_HOME}"

  service ssh start || true
} 1>/login.log 2>&1

sudo -u "#${THIS_BUILD_UID}" --preserve-env HOME="${THIS_BUILD_HOME}" PYTHONPATH="${PYTHONPATH}" PATH="${THIS_BUILD_HOME}/.local/bin:${GOPATH}/bin:${PATH}" "${COMMAND_ARGS[@]}"
