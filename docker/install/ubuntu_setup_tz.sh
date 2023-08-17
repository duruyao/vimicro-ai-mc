#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

export DEBIAN_FRONTEND=noninteractive
export TZ=Etc/UTC
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} >/etc/timezone
