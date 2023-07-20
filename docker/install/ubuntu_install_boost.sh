#!/usr/bin/env bash

set -e
set -u
set -o pipefail

# install libboost_python3.7 on Ubuntu 18.04 LTS
mkdir -p /install/ubuntu_install_boost
pushd /install/ubuntu_install_boost

curl -ksSLO https://boostorg.jfrog.io/artifactory/main/release/1.67.0/source/boost_1_67_0.tar.gz
tar -zxvf boost_1_67_0.tar.gz
pushd boost_1_67_0
chmod +x ./bootstrap.sh
./bootstrap.sh --with-python="$(which python3.7)"
./b2 install --with-python --with-system --with-filesystem --with-thread --with-regex
ln -s /usr/local/lib/libboost_python37.so.1.67.0 /usr/local/lib/libboost_python.so
ln -s /usr/local/lib/libboost_python37.a /usr/local/lib/libboost_python.a
popd

popd
rm -rf /install/ubuntu_install_boost
