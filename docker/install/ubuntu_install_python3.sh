#!/usr/bin/env bash

set -e
set -u
set -o pipefail

apt-get update && apt-install-and-clear -y --no-install-recommends \
  lsb-core \
  software-properties-common

PYTHON_VERSION="3.7"
if [ "${1-}" == "3.8" ] || [ "${1-}" == "3.9" ]; then
  PYTHON_VERSION="${1}"
fi
add-apt-repository -y ppa:deadsnakes/ppa

apt-get update && apt-install-and-clear -y --no-install-recommends \
  acl \
  python"${PYTHON_VERSION}" \
  python"${PYTHON_VERSION}"-dev \
  python"${PYTHON_VERSION}"-venv \
  python"${PYTHON_VERSION}"-distutils

#python"${PYTHON_VERSION}" -c "$(curl -kfsSL "https://bootstrap.pypa.io/get-pip.py")"
curl -ksSLO "https://bootstrap.pypa.io/get-pip.py" &&
  python"${PYTHON_VERSION}" get-pip.py &&
  rm -f get-pip.py

update-alternatives --install /usr/bin/python python /usr/bin/python"${PYTHON_VERSION}" 1
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python"${PYTHON_VERSION}" 1
#pushd /usr/bin &&
#  ln -sf python"${PYTHON_VERSION}" /usr/bin/python3 &&
#  ln -sf python"${PYTHON_VERSION}"m /usr/bin/python3m &&
#  ln -sf python"${PYTHON_VERSION}"-config /usr/bin/python3-config &&
#  ln -sf python"${PYTHON_VERSION}"m-config /usr/bin/python3m-config
#popd

pip3 config set global.no-cache-dir true
