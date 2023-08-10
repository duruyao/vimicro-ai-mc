#!/usr/bin/env bash

set -x

# usage:
# nohup bash build.sh >/dev/null 2>&1 &
# tail -f nohup-cpu.out
# tail -f nohup-gpu.out
# tail -f nohup-cpu_arm.out

docker buildx create --use --name insecure-builder --buildkitd-flags '--allow-insecure-entitlement security.insecure' || true

docker buildx build --allow security.insecure --platform linux/amd64    -t duruyao/vimicro-mc:cpu     -f Dockerfile.cpu     --load . --progress plain >nohup-cpu.out     2>&1
docker buildx build --allow security.insecure --platform linux/amd64    -t duruyao/vimicro-mc:gpu     -f Dockerfile.gpu     --load . --progress plain >nohup-gpu.out     2>&1
docker buildx build --allow security.insecure --platform linux/arm64/v8 -t duruyao/vimicro-mc:cpu_arm -f Dockerfile.cpu_arm --load . --progress plain >nohup-cpu-arm.out 2>&1

docker manifest push duruyao/vimicro-mc:cpu
docker manifest push duruyao/vimicro-mc:gpu
docker manifest push duruyao/vimicro-mc:cpu_arm
