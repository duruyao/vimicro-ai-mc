#!/usr/bin/env bash

set -euxo pipefail

docker buildx create --use --name insecure-builder --buildkitd-flags '--allow-insecure-entitlement security.insecure' || true

nohup docker buildx build --allow security.insecure --platform linux/arm64/v8 -t vimicro-ai-mc:768_cpu -f Dockerfile.cpu_arm . --progress plain > nohup.out 2>&1 &

tail -f nohup.out

