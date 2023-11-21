#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage: bash ${0}

apt-get update && apt-install-and-clear -y --no-install-recommends \
  apt-utils \
  sudo \
  build-essential \
  gcc \
  g++ \
  make \
  cmake \
  ninja-build \
  autoconf \
  automake \
  gdb \
  gdbserver \
  tree \
  git \
  locales \
  locales-all \
  zip \
  unzip \
  gzip \
  tar \
  vim \
  tmux \
  openssh-server \
  rsync \
  sshpass \
  curl \
  wget \
  software-properties-common
