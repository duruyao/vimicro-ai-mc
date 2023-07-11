#!/usr/bin/env bash

set -e
set -u
set -o pipefail

pip3 install --no-cache-dir \
  onnx==1.12.0 \
  onnxruntime==1.12.1 \
  onnxoptimizer==0.2.7
