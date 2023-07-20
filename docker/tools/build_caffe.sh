#!/usr/bin/env bash

set -e
set -u
set -o pipefail

pushd caffe

bash protopp --proto_path=src/caffe/proto --pp_out=/tmp/proto -DIS_VC0768 caffe.proto
cp /tmp/proto/caffe.proto src/caffe/proto/caffe.proto

cmake -H. -B build \
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
cmake --build build --target pycaffe -- -j $(($(nproc) - 1))
#cmake --build build --target test -- -j $(($(nproc) - 1))
cmake --build build --target install

rm -rf /tmp/caffe
mkdir -p /tmp/caffe/build_release
cp -rf ../opt/caffe/lib /tmp/caffe/build_release/
cp -rf ../opt/caffe/python /tmp/caffe/

popd
