#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

ONNX_MODIFIER_VERSION="master"
if [ "${1:-"DEFAULT_VALUE"}" != "DEFAULT_VALUE" ]; then
  ONNX_MODIFIER_VERSION="${1}"
fi

pushd /opt

git clone https://github.com/ZhangGe6/onnx-modifier.git --branch "${ONNX_MODIFIER_VERSION}" --depth 1
pushd onnx-modifier
python3 -m venv "venv"
source venv/bin/activate
pip3 install -r requirements.txt
deactivate
cp -rf *.py /
cp -rf utils /
cp -rf static /
cp -rf templates /
popd

popd
