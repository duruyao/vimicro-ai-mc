#!/usr/bin/env bash

set -e
set -u
set -o pipefail

CMAKE_VERSION="3.27.3"
if [ "${1:-"DEFAULT_VALUE"}" != "DEFAULT_VALUE" ]; then
  CMAKE_VERSION="${1}"
fi

mkdir -p /install/ubuntu_install_cmake
pushd /install/ubuntu_install_cmake

echo "Installing cmake ${CMAKE_VERSION}"
wget "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz"
tar -zxvf "cmake-${CMAKE_VERSION}.tar.gz"
pushd "cmake-${CMAKE_VERSION}"
chmod +x ./bootstrap
./bootstrap --prefix=/usr/local
make -j $(($(nproc) - 1))
make install
popd

popd
rm -rf /install/ubuntu_install_cmake
