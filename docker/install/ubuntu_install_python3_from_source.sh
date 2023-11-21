#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage: bash ${0} [PYTHON_VERSION]

PYTHON_VERSION="3.9.17"
if [ "${1:-"DEFAULT_VALUE"}" != "DEFAULT_VALUE" ]; then
  PYTHON_VERSION="${1}"
fi

apt-get update && apt-install-and-clear -y --no-install-recommends \
  build-essential \
  zlib1g-dev \
  libncurses5-dev \
  libgdbm-dev \
  libnss3-dev \
  libssl-dev \
  libreadline-dev \
  libffi-dev \
  libsqlite3-dev \
  libbz2-dev \
  libc6-dev \
  tk-dev \
  lzma \
  lzma-dev \
  liblzma-dev \
  wget

mkdir -p /install/ubuntu_install_python3_from_source
pushd /install/ubuntu_install_python3_from_source

wget "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz"
tar -xf "Python-${PYTHON_VERSION}.tar.xz"
pushd "Python-${PYTHON_VERSION}"
./configure CFLAGS="-fPIC" --enable-optimizations --enable-shared --prefix=/usr
make -j $(($(nproc) - 1))
make altinstall
popd

PYTHON_VERSION="$(echo "${PYTHON_VERSION}" | cut -d. -f1-2)"
# python"${PYTHON_VERSION}" -c "$(curl -kfsSL "https://bootstrap.pypa.io/get-pip.py")"
curl -ksSLO "https://bootstrap.pypa.io/get-pip.py" &&
  python"${PYTHON_VERSION}" get-pip.py &&
  rm -f get-pip.py

update-alternatives --install /usr/bin/python python /usr/bin/python"${PYTHON_VERSION}" 1
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python"${PYTHON_VERSION}" 1
# ln -sf /usr/bin/python"${PYTHON_VERSION}" /usr/bin/python3
# ln -sf /usr/bin/python"${PYTHON_VERSION}"m /usr/bin/python3m
# ln -sf /usr/bin/python"${PYTHON_VERSION}"-config /usr/bin/python3-config
# ln -sf /usr/bin/python"${PYTHON_VERSION}"m-config /usr/bin/python3m-config

pip3 config set global.no-cache-dir true

popd
rm -rf /install/ubuntu_install_python3_from_source
