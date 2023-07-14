#!/usr/bin/env bash

set -e
set -u
set -o pipefail

pushd pto2caffe

find . -type f -name "*.py" -exec sed -i "s/np\.bool/np\.bool_/g" {} +

sed -i "s|set(Torch_INSTALL_DIR \"/usr/local/envs/mc/lib/python3.7/site-packages/torch\" CACHE STRING \"\")|set(Torch_INSTALL_DIR \"/usr/local/lib/python3.8/dist-packages/torch\" CACHE STRING \"\")|" pto2caffe/pytorch2caffe/pnnx/CMakeLists.txt

python3 setup.py --build_type="release" --jobs="7" "--is_vc0768"

popd