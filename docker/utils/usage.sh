#!/usr/bin/env bash

set -e
set -u
set -o pipefail

BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"

BG_BLACK="\033[0;40m"
BG_RED="\033[0;41m"
BG_GREEN="\033[0;42m"
BG_YELLOW="\033[0;43m"
BG_BLUE="\033[0;44m"
BG_MAGENTA="\033[0;45m"
BG_CYAN="\033[0;46m"
BG_WHITE="\033[0;47m"

BOLD_BLACK="\033[1;30m"
BOLD_RED="\033[1;31m"
BOLD_GREEN="\033[1;32m"
BOLD_YELLOW="\033[1;33m"
BOLD_BLUE="\033[1;34m"
BOLD_MAGENTA="\033[1;35m"
BOLD_CYAN="\033[1;36m"
BOLD_WHITE="\033[1;37m"

NC="\033[0m"
BOLD="\033[1m"
NBOLD="${NC}"
CMD="\033[7m  "
NCMD="  ${NC}"

echo -e "${BOLD}
 __   __  _____    _    _                       _____            __  __    _____
 \ \ / / |  __ \  | |  | |              /\     |_   _|          |  \/  |  / ____|
  \ V /  | |__) | | |  | |  ______     /  \      | |    ______  | \  / | | |
   > <   |  ___/  | |  | | |______|   / /\ \     | |   |______| | |\/| | | |
  / . \  | |      | |__| |           / ____ \   _| |_           | |  | | | |____
 /_/ \_\ |_|       \____/           /_/    \_\ |_____|          |_|  |_|  \_____|${NBOLD}

 Release  Version: 0.9.1 (cpu only)
 Current Platform: linux/arm64/v8
 Target  Platform: vimicro vc0768 soc
${BOLD}
1) Launch the docker image${NBOLD}
  Move to a workspace with complete code and data:
  ${CMD}cd /path/to/your_workspace${NCMD}

  Launch the docker image and use the built-in model compilation tools:
  ${CMD}docker run -it --rm -w \$PWD -v \$(realpath \$PWD):\$PWD duruyao/xpu-ai-mc:768 bash${NCMD}

  Launch the docker image and install the latest model compilation tools (${BOLD}NOT REQUIRED${NBOLD}):
  ${CMD}docker run -it --rm -w \$PWD -v \$(realpath \$PWD):\$PWD -v /path/to/mc_release:/opt/mc duruyao/xpu-ai-mc:768 bash${NCMD}
${BOLD}
2) Convert other AI models to Caffe models${NBOLD}
  See how to convert other AI models to Caffe models:
  ${CMD}pto2caffe --help${NCMD}
${BOLD}
3) Convert Caffe models to NPU models${NBOLD}
  See how to convert Caffe models to NPU models:
  ${CMD}caffe2npu --help${NCMD}
${BOLD}
4) Examples${NBOLD}
  ${BOLD}*${NBOLD} /opt/mc/example/AlexNet
  ${BOLD}*${NBOLD} /opt/mc/example/DenseNet121
  ${BOLD}*${NBOLD} /opt/mc/example/GoogLeNet
  ${BOLD}*${NBOLD} /opt/mc/example/ResNet18
  ${BOLD}*${NBOLD} /opt/mc/example/YOLOv3
  ${BOLD}*${NBOLD} /opt/mc/example/YOLOv5s
"
