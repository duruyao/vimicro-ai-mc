#!/usr/bin/env bash

set -euo pipefail

cd "${ONNX_MODIFIER_HOME}"
source venv/bin/activate
python3 app.py --host='0.0.0.0' --port=80 --debug=True
deactivate
