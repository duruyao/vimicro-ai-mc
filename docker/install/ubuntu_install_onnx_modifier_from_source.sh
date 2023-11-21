#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage: bash ${0} [ONNX_MODIFIER_VERSION]

ONNX_MODIFIER_VERSION="master"
if [ "${1:-"DEFAULT_VALUE"}" != "DEFAULT_VALUE" ]; then
  ONNX_MODIFIER_VERSION="${1}"
fi

git clone --branch "${ONNX_MODIFIER_VERSION}" --recurse-submodules --depth 1 https://github.com/ZhangGe6/onnx-modifier.git "${ONNX_MODIFIER_HOME}"
pushd "${ONNX_MODIFIER_HOME}"
python3 -m venv "venv"
source venv/bin/activate
pip3 install -r requirements.txt
deactivate
popd
