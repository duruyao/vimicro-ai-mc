#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage: bash ${0}

pip3 install --no-cache-dir nvidia-pyindex

pip3 install --no-cache-dir \
  scikit-image \
  lmdb \
  pycrypto \
  pandas \
  dill \
  openpyxl \
  numpy \
  pillow \
  onnx-graphsurgeon \
  onnx-simplifier \
  opencv-python
