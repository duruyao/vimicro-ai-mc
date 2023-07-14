#!/usr/bin/env bash

set -e
set -u
set -o pipefail

# install opencv3 on Ubuntu 20.04 LTS
mkdir -p /install/ubuntu_install_opencv3
pushd /install/ubuntu_install_opencv3

git clone https://github.com/opencv/opencv_contrib.git --branch 3.3.1 --depth 1
git clone https://github.com/opencv/opencv.git --branch 3.3.1 --depth 1
pushd opencv
sed -i "s/char\* str = PyString_AsString(obj);/const char\* str = PyString_AsString(obj);/g" modules/python/src2/cv2.cpp
sed -i "1i\\
#define AV_CODEC_FLAG_GLOBAL_HEADER (1 << 22)\\
#define CODEC_FLAG_GLOBAL_HEADER AV_CODEC_FLAG_GLOBAL_HEADER\\
#define AVFMT_RAWPICTURE 0x0020" modules/videoio/src/cap_ffmpeg_impl.hpp
cmake -H. -B build -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_INSTALL_PREFIX=/opt/opencv3 \
  -D BUILD_EXAMPLES=OFF \
  -D INSTALL_C_EXAMPLES=OFF \
  -D INSTALL_PYTHON_EXAMPLES=OFF \
  -D WITH_CUDA=OFF \
  -D BUILD_opencv_xfeatures2d=OFF \
  -D BUILD_opencv_python2=OFF \
  -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules
cmake --build build --target all -- -j $(($(nproc) - 1))
cmake --build build --target install
popd

popd
rm -rf /install/ubuntu_install_opencv3
