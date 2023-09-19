#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

pip3 install --no-cache-dir future

pip3 install --no-cache-dir \
  torch==1.10.2 \
  torchvision==0.11.3
