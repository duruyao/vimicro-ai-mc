#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

apt-get update && apt-install-and-clear -y --no-install-recommends \
  build-essential \
  cmake \
  git \
  wget \
  libatlas-base-dev \
  libboost-all-dev \
  libgflags-dev \
  libgoogle-glog-dev \
  libhdf5-serial-dev \
  libleveldb-dev \
  liblmdb-dev \
  libopencv-dev \
  libprotobuf-dev \
  libsnappy-dev \
  protobuf-compiler

wget https://raw.githubusercontent.com/duruyao/caffe/v1.0.1/python/requirements.txt
for req in $(cat requirements.txt) pydot; do
  pip3 install --upgrade --no-cache-dir "${req}"
done
rm -f requirements.txt