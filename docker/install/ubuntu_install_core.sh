#!/usr/bin/env bash

set -e
set -u
set -o pipefail

export DEBIAN_FRONTEND=noninteractive
export TZ=Etc/UTC
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} >/etc/timezone

apt-get update && apt-install-and-clear -y --no-install-recommends \
  apt-transport-https \
  ca-certificates \
  curl \
  g++ \
  gdb \
  git \
  graphviz \
  libcurl4-openssl-dev \
  libopenblas-dev \
  libssl-dev \
  libtinfo-dev \
  libz-dev \
  lsb-core \
  make \
  ninja-build \
  parallel \
  pkg-config \
  sudo \
  unzip \
  wget
