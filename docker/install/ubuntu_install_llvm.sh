#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage: bash ${0} [LLVM_VERSION_1] [LLVM_VERSION_2] ...

# fix error: ModuleNotFoundError: No module named 'apt_pkg'
ln -sf /usr/lib/python3/dist-packages/apt_pkg.cpython-*.so /usr/lib/python3/dist-packages/apt_pkg.so

if [ $# -eq 0 ]; then
  # install in non-interactive mode: add-apt-repository "${REPO_NAME}" -y
  bash -c "$(wget -O - https://apt.llvm.org/llvm.sh |
    sed "s/add-apt-repository \"\${REPO_NAME}\"/add-apt-repository \"\${REPO_NAME}\" -y/g")"
else
  for LLVM_VERSION in "${@}"; do
    bash -c "$(wget -O - https://apt.llvm.org/llvm.sh |
      sed "s/add-apt-repository \"\${REPO_NAME}\"/add-apt-repository \"\${REPO_NAME}\" -y/g")" _ "${LLVM_VERSION}"
  done
fi
