#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

pip3 install --no-cache-dir \
  onnx==1.14.0 \
  onnxruntime==1.15.1 \
  onnxoptimizer==0.3.13
