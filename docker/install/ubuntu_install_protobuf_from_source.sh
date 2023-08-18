#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

PROTOBUF_VERSION="3.17.2"
if [ "${1:-"DEFAULT_VALUE"}" != "DEFAULT_VALUE" ]; then
  PROTOBUF_VERSION="${1}"
fi

apt-get remove -y --purge protobuf-compiler libprotobuf-dev

apt-get update && apt-install-and-clear -y --no-install-recommends \
  g++ \
  bazel \
  make \
  autoconf \
  automake \
  libtool

mkdir -p /install/ubuntu_install_protobuf_from_source
pushd /install/ubuntu_install_protobuf_from_source

wget "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protobuf-all-${PROTOBUF_VERSION}.tar.gz"
tar -zxvf "protobuf-all-${PROTOBUF_VERSION}.tar.gz"
pushd "protobuf-${PROTOBUF_VERSION}"
./autogen.sh
./configure --prefix=/usr/local
make -j $(($(nproc) - 1))
make install
ldconfig
popd

popd
rm -rf /install/ubuntu_install_protobuf_from_source
