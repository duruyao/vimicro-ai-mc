#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage: [KEY_1=VALUE_1] [KEY_2=VALUE_2] ... bash ${0} [TVM_VERSION]

TVM_VERSION="0.14.0"
if [ "${1:-"DEFAULT_VALUE"}" != "DEFAULT_VALUE" ]; then
  TVM_VERSION="${1}"
fi

apt-get update && apt-get install -y --no-install-recommends \
  python3 \
  python3-dev \
  python3-setuptools \
  gcc \
  libtinfo-dev \
  zlib1g-dev \
  build-essential \
  cmake \
  libedit-dev \
  libxml2-dev

python"${TVM_PYTHON_VERSION}" -m pip install --upgrade --no-cache-dir pip
python"${TVM_PYTHON_VERSION}" -m pip install --upgrade --no-cache-dir \
  "Pygments>=2.4.0" \
  attrs \
  cloudpickle \
  cython \
  decorator \
  mypy \
  numpy \
  orderedset \
  packaging \
  Pillow \
  psutil \
  pytest \
  git+https://github.com/tlc-pack/tlcpack-sphinx-addon.git@768ec1dce349fe4708f6ad68be1ebb3f3dabafa1 \
  pytest-profiling \
  pytest-xdist \
  pytest-rerunfailures==10.2 \
  requests \
  scipy \
  Jinja2 \
  junitparser==2.4.2 \
  six \
  tornado \
  pytest-lazy-fixture \
  ml_dtypes

git clone --branch "v${TVM_VERSION}" --recurse-submodules --depth 1 https://github.com/apache/tvm.git "${TVM_HOME}"
pushd "${TVM_HOME}"
cmake -S . -B build \
  -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_INSTALL_PREFIX="${TVM_HOME}" \
  -D USE_LLVM="${TVM_BUILD_USE_LLVM}" \
  -D USE_CUDA="${TVM_BUILD_USE_CUDA}" \
  -D USE_CUDNN="${TVM_BUILD_USE_CUDNN}" \
  -D CUDA_ARCH_NAME=Manual \
  -D CUDA_ARCH_BIN="50 52 60 61 70 75 80 86 89 90" \
  -D CUDA_ARCH_PTX="70" \
  -D CUDA_NVCC_FLAGS="-O3"
cmake --build build --target all -- -j $(($(nproc) - 1))
cmake --build build --target install
mkdir -p lib && cp -rf build/libtvm*.so lib/ && rm -rf build
popd
