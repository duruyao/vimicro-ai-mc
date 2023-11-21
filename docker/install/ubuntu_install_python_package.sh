#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage: bash ${0}

pip3 install --upgrade --no-cache-dir \
  "Pygments>=2.4.0" \
  attrs \
  cloudpickle \
  cython \
  decorator \
  mypy \
  numpy==1.21.* \
  orderedset \
  packaging \
  Pillow==9.1.0 \
  psutil \
  pytest \
  git+https://github.com/tlc-pack/tlcpack-sphinx-addon.git@768ec1dce349fe4708f6ad68be1ebb3f3dabafa1 \
  pytest-profiling \
  pytest-xdist \
  pytest-rerunfailures==10.2 \
  requests \
  scipy \
  Jinja2 \
  junitparser==2.4.2 \
  six \
  tornado \
  pytest-lazy-fixture
