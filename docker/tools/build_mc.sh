#!/usr/bin/env bash

set -e
set -u
set -o pipefail

sed -i "s|if iw_policy is not \"\" and iw_policy is not None|if iw_policy != \"\" and iw_policy is not None|g" tools/python_mc/npu_cfg_policy.py

sed -i "s|x86_64|aarch64|g" tools/modelconverter/Makefile
sed -i "s|PYTHON_VER := python\$(PY_VER)m|PYTHON_VER := python\$(PY_VER)|g" tools/modelconverter/Makefile
sed -i "s|LBOOST_PYTHON := lboost_python3|LBOOST_PYTHON := lboost_python\$(subst .,,\$(PY_VER))|g" tools/modelconverter/Makefile
sed -i "85i\\
CXXFLAGS += \$(shell python3-config --cflags --libs)\\
LDFLAGS += \$(shell python3-config --ldflags)" tools/modelconverter/Makefile

sed -i "s|if \[ \"\${build_type}\" == \"release\" \]; then|if \[ \"\${build_type}\" == \"release\" \] \&\& False; then|" build.sh
bash build.sh -BUILD_TYPE="release" -PY_VER="3.8"
