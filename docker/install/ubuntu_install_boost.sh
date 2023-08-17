#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

BOOST_VERSION="1.67.0"
BOOST_TAR_NAME="boost_1_67_0"
if [ "${1:-"DEFAULT_VALUE"}" != "DEFAULT_VALUE" ]; then
  BOOST_VERSION="${1}"
  BOOST_TAR_NAME="boost_${BOOST_VERSION//./_}"
fi

PYTHON_VERSION="3.7"
PY_VERSION="37"
if [ "${2:-"DEFAULT_VALUE"}" != "DEFAULT_VALUE" ]; then
  PYTHON_VERSION="${2}"
  PY_VERSION="${2//./}"
fi

mkdir -p /install/ubuntu_install_boost
pushd /install/ubuntu_install_boost

curl -ksSLO "https://boostorg.jfrog.io/artifactory/main/release/${BOOST_VERSION}/source/${BOOST_TAR_NAME}.tar.gz"
tar -zxvf "${BOOST_TAR_NAME}.tar.gz"
pushd "${BOOST_TAR_NAME}"
chmod +x ./bootstrap.sh
./bootstrap.sh --with-libraries=all --with-python="$(which python"${PYTHON_VERSION}")" --prefix=/usr/local
./b2 install -j $(($(nproc) - 1))
ln -s "/usr/local/lib/libboost_python${PY_VERSION}.so.${BOOST_VERSION}" /usr/local/lib/libboost_python.so
ln -s "/usr/local/lib/libboost_python${PY_VERSION}.a" /usr/local/lib/libboost_python.a
popd

popd
rm -rf /install/ubuntu_install_boost
