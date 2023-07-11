#!/usr/bin/env bash

set -e
set -u
set -o pipefail

apt-install-and-clear -y --no-install-recommends libhdf5-dev

pip3 install --no-cache-dir \
  keras==2.9 \
  tensorflow-aarch64==2.9.1 \
  tflite
