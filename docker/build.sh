#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

# usage:
# nohup bash build.sh >/dev/null 2>&1 &
# tail -f nohup-gpu.out
# tail -f nohup-cpu.out
# tail -f nohup-cpu_arm.out

docker build --build-arg BUILD_DATE="$(TZ=UTC-8 date "+%Y-%m-%dT%H:%M:%S+08:00")" -t duruyao/vimicro-mc:gpu -f Dockerfile.gpu --load . --progress plain >nohup-gpu.out 2>&1
docker image tag duruyao/vimicro-mc:gpu duruyao/vimicro-mc:gpu-cuda11.8.0-cudnn8-ubuntu22.04
docker push duruyao/vimicro-mc:gpu
docker push duruyao/vimicro-mc:gpu-cuda11.8.0-cudnn8-ubuntu22.04

docker build --build-arg BUILD_DATE="$(TZ=UTC-8 date "+%Y-%m-%dT%H:%M:%S+08:00")" -t duruyao/vimicro-mc:cpu -f Dockerfile.cpu --load . --progress plain >nohup-cpu.out 2>&1
docker image tag duruyao/vimicro-mc:cpu duruyao/vimicro-mc:cpu-ubuntu22.04
docker push duruyao/vimicro-mc:cpu
docker push duruyao/vimicro-mc:cpu-ubuntu22.04

#docker buildx create --use --name insecure-builder --buildkitd-flags "--allow-insecure-entitlement security.insecure" || true
#docker buildx build --allow security.insecure --platform linux/arm64/v8 -t duruyao/vimicro-mc:cpu_arm -f Dockerfile.cpu_arm --load . --progress plain >nohup-cpu-arm.out 2>&1
#docker push duruyao/vimicro-mc:cpu_arm
