#!/usr/bin/env bash

set -e
set -u
set -o pipefail

pip3 install --upgrade \
  scikit-image \
  python-lmdb \
  pycrypto \
  pandas \
  dill \
  openpyxl \
  numpy \
  pillow --no-cache-dir
