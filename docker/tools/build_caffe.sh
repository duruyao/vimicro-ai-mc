#!/usr/bin/env bash

set -e
set -u
set -o pipefail

pushd caffe

bash protopp --proto_path=src/caffe/proto --pp_out=/tmp/proto -DIS_VC0768 caffe.proto
cp /tmp/proto/caffe.proto src/caffe/proto/caffe.proto

rm -rf build build_release

cmake -H. -B build -D CMAKE_PREFIX_PATH=/opt/opencv3 \
  -D CMAKE_INSTALL_PREFIX=../opt/caffe \
  -D CMAKE_BUILD_TYPE=Release \
  -D CPU_ONLY=1 \
  -D python_version=3 \
  -D USE_OPENCV=ON \
  -D USE_LEVELDB=ON \
  -D USE_LMDB=ON \
  -D BUILD_docs=OFF \
  -D BLAS=open
#cmake --build build --target all -- -j $(($(nproc) - 1))
#cmake --build build --target test -- -j $(($(nproc) - 1))
cmake --build build --target pycaffe -- -j $(($(nproc) - 1))
cmake --build build --target install

ln -s build build_release

popd
