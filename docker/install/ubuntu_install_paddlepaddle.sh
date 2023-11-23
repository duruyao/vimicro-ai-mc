#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage: bash ${0}

pip3 install --no-cache-dir \
  paddlepaddle==2.5.2 \
  paddleocr==2.7.0.3 --ignore-installed
