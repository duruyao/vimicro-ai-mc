
# export MCHOME="/opt/mc"
# export PYTHONPATH="$MCHOME/toolchain/caffe/python:$PYTHONPATH"
# export LD_LIBRARY_PATH="$MCHOME/toolchain/caffe/build/lib:$LD_LIBRARY_PATH"
# export LD_PRELOAD="/usr/local/lib/python3.7/dist-packages/torch/lib/libgomp-d22c30c5.so.1 $LD_PRELOAD"
alias pto2caffe="python3 $MCHOME/toolchain/pto2caffe/convert.pyc"
alias caffe2npu="python3 $MCHOME/toolchain/caffe2npu/model_converter.pyc"
PS1="\[\e[35;1m\][mc]\[\e[33;1m\][\[\e[33;1m\]\u\[\e[31;1m\]@\[\e[33;1m\]\h\[\e[37;1m\]:\[\e[34;1m\]\w\[\e[33;1m\]]\[\e[37;1m\]\\$\[\e[0m\] "
