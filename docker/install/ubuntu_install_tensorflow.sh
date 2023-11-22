#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage: bash ${0}

apt-install-and-clear -y --no-install-recommends libhdf5-dev

pip3 install --no-cache-dir \
  keras==2.15.0 \
  tensorflow==2.15.0
