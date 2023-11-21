#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage: bash ${0} [ABSEIL_VERSION]

ABSEIL_VERSION="20220623.0"
if [ "${1:-"DEFAULT_VALUE"}" != "DEFAULT_VALUE" ]; then
  ABSEIL_VERSION="${1}"
fi

mkdir -p /install/ubuntu_install_abseil_from_source
pushd /install/ubuntu_install_abseil_from_source

git clone https://github.com/abseil/abseil-cpp --branch "${ABSEIL_VERSION}" --depth 1
pushd abseil-cpp
cmake -H. -B build \
  -D BUILD_SHARED_LIBS=ON \
  -D CMAKE_CXX_STANDARD=11 \
  -D CMAKE_BUILD_TYPE=Release \
  -D ABSL_ENABLE_INSTALL=ON \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  -D CMAKE_POSITION_INDEPENDENT_CODE=ON \
  -D CMAKE_SKIP_BUILD_RPATH=OFF \
  -D CMAKE_BUILD_WITH_INSTALL_RPATH=OFF \
  -D CMAKE_INSTALL_RPATH=/usr/local/lib \
  -D CMAKE_INSTALL_RPATH_USE_LINK_PATH=ON
cmake --build build --target all -- -j $(($(nproc) - 1))
cmake --build build --target install
popd

popd
rm -rf /install/ubuntu_install_abseil_from_source
