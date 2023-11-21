#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage: bash ${0} [OPENCV_VERSION]

OPENCV_VERSION="3.4.2"
if [ "${1:-"DEFAULT_VALUE"}" != "DEFAULT_VALUE" ]; then
  OPENCV_VERSION="${1}"
fi

mkdir -p /install/ubuntu_install_opencv3_from_source
pushd /install/ubuntu_install_opencv3_from_source

git clone https://github.com/opencv/opencv_contrib.git --branch "${OPENCV_VERSION}" --depth 1
git clone https://github.com/opencv/opencv.git --branch "${OPENCV_VERSION}" --depth 1
pushd opencv
cmake -S . -B build \
  -D CMAKE_CXX_STANDARD=11 \
  -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  -D BUILD_EXAMPLES=OFF \
  -D BUILD_opencv_python2=OFF \
  -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules
cmake --build build --target all -- -j $(($(nproc) - 1))
cmake --build build --target install
popd

popd
rm -rf /install/ubuntu_install_opencv3_from_source
