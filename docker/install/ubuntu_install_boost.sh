#!/usr/bin/env bash

set -e
set -u
set -o pipefail

# install libboost_python3.7 on Ubuntu 18.04 LTS
mkdir -p /install/ubuntu_install_boost
pushd /install/ubuntu_install_boost

PYTHON_VERSION="3.7"
PY_VERSION="37"
if [ "${1:-"DEFAULT_VALUE"}" != "DEFAULT_VALUE" ]; then
  PYTHON_VERSION="${1}"
  PY_VERSION="${1//./}"
fi

curl -ksSLO https://boostorg.jfrog.io/artifactory/main/release/1.67.0/source/boost_1_67_0.tar.gz
tar -zxvf boost_1_67_0.tar.gz
pushd boost_1_67_0
chmod +x ./bootstrap.sh
./bootstrap.sh --with-libraries=all --with-python="$(which python"${PYTHON_VERSION}")" --prefix=/usr/local
./b2 install -j $(($(nproc) - 1))
ln -s /usr/local/lib/libboost_python"${PY_VERSION}".so.1.67.0 /usr/local/lib/libboost_python.so
ln -s /usr/local/lib/libboost_python"${PY_VERSION}".a /usr/local/lib/libboost_python.a
popd

popd
rm -rf /install/ubuntu_install_boost
