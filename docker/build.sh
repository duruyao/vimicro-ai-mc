docker buildx create --use --name insecure-builder --buildkitd-flags '--allow-insecure-entitlement security.insecure' || true

nohup docker buildx build --allow security.insecure --platform linux/amd64    -t duruyao/xpu-ai-mc:768_cpu -f Dockerfile.cpu     --load . --progress plain > nohup-cpu.out 2>&1 &
nohup docker buildx build --allow security.insecure --platform linux/arm64/v8 -t duruyao/xpu-ai-mc:768_arm -f Dockerfile.cpu_arm --load . --progress plain > nohup-arm.out 2>&1 &
nohup docker buildx build --allow security.insecure --platform linux/amd64    -t duruyao/xpu-ai-mc:768_gpu -f Dockerfile.gpu     --load . --progress plain > nohup-gpu.out 2>&1 &

tail -f nohup*.out

if ! grep -q "\"experimental\": true" /etc/docker/daemon.json; then
  echo "Cannot find \033[7m\"experimental\": true\033[0m in /etc/docker/daemon.json"
  exit 1
fi

docker manifest create duruyao/xpu-ai-mc:768 duruyao/xpu-ai-mc:768_cpu duruyao/xpu-ai-mc:768_arm
docker manifest push duruyao/xpu-ai-mc:768
docker manifest push duruyao/xpu-ai-mc:768_gpu
