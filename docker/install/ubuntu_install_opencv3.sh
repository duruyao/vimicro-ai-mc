#!/usr/bin/env bash

set -e
set -u
set -o pipefail

# remove opencv4 and install opencv3 on Ubuntu 20.04 LTS
apt-get update && apt-install-and-clear -y --no-install-recommends software-properties-common
apt-get remove --autoremove -y libopencv-dev
add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
apt-get update && apt-install-and-clear -y --no-install-recommends libopencv-dev
pkg-config --modversion opencv
