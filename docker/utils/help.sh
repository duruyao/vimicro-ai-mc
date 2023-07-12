#!/usr/bin/env bash

set -e
set -u
set -o pipefail

cat <<EOF

 __      __  _____   __  __   _____    _____   _____     ____                        _____            __  __    _____
 \ \    / / |_   _| |  \/  | |_   _|  / ____| |  __ \   / __ \               /\     |_   _|          |  \/  |  / ____|
  \ \  / /    | |   | \  / |   | |   | |      | |__) | | |  | |  ______     /  \      | |    ______  | \  / | | |
   \ \/ /     | |   | |\/| |   | |   | |      |  _  /  | |  | | |______|   / /\ \     | |   |______| | |\/| | | |
    \  /     _| |_  | |  | |  _| |_  | |____  | | \ \  | |__| |           / ____ \   _| |_           | |  | | | |____
     \/     |_____| |_|  |_| |_____|  \_____| |_|  \_\  \____/           /_/    \_\ |_____|          |_|  |_|  \_____|

0) Move to a workspace with complete code and data.
  cd /path/to/your_workspace

1) Launch the docker image and use the built-in model compilation tools.
  docker run -it --name \$USER.mc.$((100 + RANDOM % 900)) --rm -w \$PWD -v \$(realpath \$PWD):\$PWD duruyao/vimicro-ai-mc:768_cpu bash

2) Launch the docker image and install the latest model compilation tools (NOT REQUIRED).
  docker run -it --name \$USER.mc.$((100 + RANDOM % 900)) --rm -w \$PWD -v \$(realpath \$PWD):\$PWD -v /path/to/mc_release:/opt/mc duruyao/vimicro-ai-mc:768_cpu bash

3) See how to convert other AI models to Caffe models.
  pto2caffe --help

4) See how to convert Caffe models to NPU models.
  caffe2npu --help

EOF
