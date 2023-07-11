#!/usr/bin/env bash

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
  protobuf-compiler \
  python-dev \
  python-numpy \
  python3-pip \
  python-setuptools \
  python3-scipy