#!/usr/bin/env bash

set -e
set -u
set -o pipefail

pip3 install future --no-cache-dir

pip3 install \
  torch==1.11.0 \
  torchvision==0.12.0 \
  --extra-index-url https://download.pytorch.org/whl/cpu --no-cache-dir
