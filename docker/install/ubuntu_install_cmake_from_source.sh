#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage: bash ${0} [CMAKE_VERSION]

CMAKE_VERSION="3.27.3"
if [ "${1:-"DEFAULT_VALUE"}" != "DEFAULT_VALUE" ]; then
  CMAKE_VERSION="${1}"
fi

mkdir -p /install/ubuntu_install_cmake_from_source
pushd /install/ubuntu_install_cmake_from_source

git clone --branch "v${CMAKE_VERSION}" --recurse-submodules --depth 1 https://github.com/Kitware/CMake
pushd CMake
chmod +x ./bootstrap
./bootstrap --prefix=/usr/local
make -j $(($(nproc) - 1))
make install
popd

popd
rm -rf /install/ubuntu_install_cmake_from_source
