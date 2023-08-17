#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

OPENCV_VERSION="3.3.1"
if [ "${1:-"DEFAULT_VALUE"}" != "DEFAULT_VALUE" ]; then
  OPENCV_VERSION="${1}"
fi

mkdir -p /install/ubuntu_install_opencv3_from_source
pushd /install/ubuntu_install_opencv3_from_source

git clone https://github.com/opencv/opencv_contrib.git --branch "${OPENCV_VERSION}" --depth 1
git clone https://github.com/opencv/opencv.git --branch "${OPENCV_VERSION}" --depth 1
pushd opencv
sed -i "s/char\* str = PyString_AsString(obj);/const char\* str = PyString_AsString(obj);/g" modules/python/src2/cv2.cpp
sed -i "1i\\
#define AV_CODEC_FLAG_GLOBAL_HEADER (1 << 22)\\
#define CODEC_FLAG_GLOBAL_HEADER AV_CODEC_FLAG_GLOBAL_HEADER\\
#define AVFMT_RAWPICTURE 0x0020" modules/videoio/src/cap_ffmpeg_impl.hpp
sed -i "s|CV_Assert(cost.size > 0);|CV_Assert(cost.size > (const int*)(0));|g" ../opencv_contrib/modules/stereo/src/descriptor.cpp
sed -i "s|CV_Assert(image.size > 0);|CV_Assert(image.size > (const int*)(0));|g" ../opencv_contrib/modules/stereo/src/descriptor.cpp
cmake -H. -B build -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  -D CMAKE_CXX_STANDARD=11 \
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
rm -rf /install/ubuntu_install_opencv3_from_source
