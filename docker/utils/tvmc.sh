#!/usr/bin/env bash

set -euo pipefail

python"${TVM_PYTHON_VERSION}" -m tvm.driver.tvmc "${@}"
