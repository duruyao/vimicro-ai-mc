
docker buildx create --use --name insecure-builder --buildkitd-flags '--allow-insecure-entitlement security.insecure' || true

nohup docker buildx build --allow security.insecure --platform linux/arm64/v8 -t duruyao/xpu-ai-mc:768 -f Dockerfile.cpu_arm --load . --progress plain > nohup.out 2>&1 &

tail -f nohup.out
