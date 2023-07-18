#!/usr/bin/env bash

set -e
set -u
set -o pipefail

# install cmake on Ubuntu 18.04 LTS
mkdir -p /install/ubuntu_install_cmake
pushd /install/ubuntu_install_cmake

version="3.27.0-rc5"
echo "Installing cmake ${version}"
wget "https://github.com/Kitware/CMake/releases/download/v${version}/cmake-${version}.tar.gz"
tar -zxvf "cmake-${version}.tar.gz"
pushd "cmake-${version}"
chmod +x ./bootstrap
./bootstrap
make -j $(($(nproc) - 1))
make install
popd

popd
rm -rf /install/ubuntu_install_cmake
