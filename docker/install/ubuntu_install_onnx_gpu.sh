#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage: bash ${0}

pip3 install --no-cache-dir \
  onnx==1.15.0 \
  onnxruntime-gpu==1.16.2 \
  onnxoptimizer==0.3.13
