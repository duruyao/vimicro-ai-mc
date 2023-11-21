#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage: bash ${0}

pip3 install --no-cache-dir future

pip3 install --no-cache-dir \
  torch==2.1.0 \
  torchvision==0.16.0 \
  --extra-index-url https://download.pytorch.org/whl/cpu
