#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage: bash ${0} [PROTOBUF_VERSION]

PROTOBUF_VERSION="21.1"
if [ "${1:-"DEFAULT_VALUE"}" != "DEFAULT_VALUE" ]; then
  PROTOBUF_VERSION="${1}"
fi

apt-get remove -y --purge protobuf-compiler libprotobuf-dev && true

mkdir -p /install/ubuntu_install_protobuf_from_source
pushd /install/ubuntu_install_protobuf_from_source

git clone https://github.com/protocolbuffers/protobuf.git --branch "v${PROTOBUF_VERSION}" --recurse-submodules --depth 1
pushd protobuf
cmake -S . -B build \
  -D BUILD_SHARED_LIBS=ON \
  -D CMAKE_CXX_STANDARD=11 \
  -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  -D CMAKE_POSITION_INDEPENDENT_CODE=ON \
  -D CMAKE_SKIP_BUILD_RPATH=OFF \
  -D CMAKE_BUILD_WITH_INSTALL_RPATH=OFF \
  -D CMAKE_INSTALL_RPATH=/usr/local/lib \
  -D CMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
  -D protobuf_BUILD_TESTS=OFF
cmake --build build --target all -- -j $(($(nproc) - 1))
cmake --build build --target install
popd

popd
rm -rf /install/ubuntu_install_protobuf_from_source
