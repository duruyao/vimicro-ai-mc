#!/usr/bin/env bash

set -e
set -u
set -o pipefail

apt-get install "$@" && apt-get clean
