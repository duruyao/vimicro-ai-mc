#!/usr/bin/env bash

set -e
set -u
set -o pipefail

pip3 install future --no-cache-dir

pip3 install --no-cache-dir \
  torch==1.12.0 \
  torchvision==0.13.0 \
  --extra-index-url https://download.pytorch.org/whl/cpu
