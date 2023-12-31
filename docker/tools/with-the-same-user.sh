#!/usr/bin/env bash

set -e

COMMAND_ARGS=("${@}")

mkdir -p /login

{
  set -x
  for shell in zsh fish bash sh; do
    [ -n "$(command -v "${shell}")" ] && custom_shell="$(command -v "${shell}")" && break
  done

  useradd -ms "${custom_shell-"/bin/sh"}" -d "${THIS_BUILD_HOME}" "${THIS_BUILD_USER}"
  usermod -aG sudo "${THIS_BUILD_USER}"
  echo "${THIS_BUILD_USER}":"${THIS_BUILD_USER}" | chpasswd
  usermod -u "${THIS_BUILD_UID}" "${THIS_BUILD_USER}"
  groupmod -g "${THIS_BUILD_GID}" "${THIS_BUILD_GROUP}" || true

  for config in /root/.vim /root/.vimrc /root/.bashrc /root/.zshrc /root/.zprofile /root/.oh-my-zsh /root/.tmux.conf; do
    [ -e "${config}" ] && cp -rf "${config}" "${THIS_BUILD_HOME}"/
  done

  chown -R "${THIS_BUILD_USER}":"${THIS_BUILD_USER}" "${THIS_BUILD_HOME}"

  service ssh start || true
  set +x
} 1>/login/login.log 2>&1

if [ -z "$(command -v sudo)" ]; then
  su --login "${THIS_BUILD_USER}" --pty --command "export HOME=${THIS_BUILD_HOME} PYTHONPATH=${PYTHONPATH} PATH=${THIS_BUILD_HOME}/.local/bin:${GOPATH}/bin:${PATH}; ${COMMAND_ARGS[*]}"
else
  sudo --user "#${THIS_BUILD_UID}" --preserve-env HOME="${THIS_BUILD_HOME}" PYTHONPATH="${PYTHONPATH}" PATH="${THIS_BUILD_HOME}/.local/bin:${GOPATH}/bin:${PATH}" -- "${COMMAND_ARGS[@]}"
fi
