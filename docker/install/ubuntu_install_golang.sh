#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage: bash ${0} [GO_VERSION] [GO_PLATFORM]

GO_VERSION="1.21.5"
if [ "${1:-"DEFAULT_VALUE"}" != "DEFAULT_VALUE" ]; then
  GO_VERSION="${1}"
fi

GO_PLATFORM="linux-amd64"
if [ "${2:-"DEFAULT_VALUE"}" != "DEFAULT_VALUE" ]; then
  GO_PLATFORM="${2}"
fi

mkdir -p /install/ubuntu_install_golang
pushd /install/ubuntu_install_golang

wget "https://go.dev/dl/go${GO_VERSION}.${GO_PLATFORM}.tar.gz"
tar -zxvf "go${GO_VERSION}.${GO_PLATFORM}.tar.gz" -C /opt

popd
rm -rf /install/ubuntu_install_golang
