#!/usr/bin/env bash

set -euxo pipefail

docker buildx create --use --name insecure-builder --buildkitd-flags '--allow-insecure-entitlement security.insecure' || true

docker buildx build --allow security.insecure --platform linux/arm64/v8 -t vimicro-ai-mc:768_cpu -f Dockerfile.cpu_arm .
