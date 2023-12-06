#!/usr/bin/env bash

set -e
set -u
set -o pipefail

function get_random_port() {
  local random_port
  random_port="$(shuf -i 1024-49151 -n 1)"
  if [ -n "$(command -v netstat)" ]; then
    while netstat -tuln | grep -q ":${random_port}"; do
      random_port="$(shuf -i 1024-49151 -n 1)"
    done
  fi
  echo "${random_port}"
}

OPTIONS=()
IMAGE=()
COMMAND_ARGS=()

while ((${#})); do
  repository_tag="$(docker inspect --format "{{.RepoTags}}" "${1}" 2>/dev/null || true)"
  if [ ${#repository_tag} -le 2 ]; then
    OPTIONS+=("${1}")
    shift 1
  else
    IMAGE+=("${1}")
    shift 1
    COMMAND_ARGS+=("${@}")
    break
  fi
done

CONTAINER_USER_HOME="/${USER}"
CONTAINER_CACHE_DIR="${HOME}/.docker_cache/$(docker images --format "{{.ID}}" "${IMAGE[*]}")"

mkdir -p "${CONTAINER_CACHE_DIR}/login"
mkdir -p "${CONTAINER_CACHE_DIR}/${CONTAINER_USER_HOME}/.local"

echo "
#!/usr/bin/env bash

set -e

COMMAND=(\"\${@}\")

{
  useradd -ms /bin/bash -d \"\${THIS_BUILD_HOME}\" \"\${THIS_BUILD_USER}\"
  usermod -aG sudo \"\${THIS_BUILD_USER}\"
  echo \"\${THIS_BUILD_USER}\":\"\${THIS_BUILD_USER}\" | chpasswd
  usermod -u \"\${THIS_BUILD_UID}\" \"\${THIS_BUILD_USER}\"
  groupmod -g \"\${THIS_BUILD_GID}\" \"\${THIS_BUILD_GROUP}\"

  if [ -n \"\$(command -v zsh)\" ]; then
    chsh -s \"\$(which zsh)\" \"\${THIS_BUILD_USER}\"
  fi

  cp -rf /root/.vim \"\${THIS_BUILD_HOME}\"/.vim || true
  cp -rf /root/.vimrc \"\${THIS_BUILD_HOME}\"/.vimrc || true
  cp -rf /root/.bashrc \"\${THIS_BUILD_HOME}\"/.bashrc || true
  cp -rf /root/.zshrc \"\${THIS_BUILD_HOME}\"/.zshrc || true
  cp -rf /root/.zprofile \"\${THIS_BUILD_HOME}\"/.zprofile || true
  cp -rf /root/.oh-my-zsh \"\${THIS_BUILD_HOME}\"/.oh-my-zsh || true
  cp -rf /root/.tmux.conf \"\${THIS_BUILD_HOME}\"/.tmux.conf || true
  cp -rf /root/.gitconfig \"\${THIS_BUILD_HOME}\"/.gitconfig || true

  chown -R \"\${THIS_BUILD_USER}\":\"\${THIS_BUILD_USER}\" \"\${THIS_BUILD_HOME}\"

  service ssh start || true
} 1>/login.log 2>&1

sudo -u \"#\${THIS_BUILD_UID}\" --preserve-env HOME=\"\${THIS_BUILD_HOME}\" \"\${COMMAND[@]}\"

" >"${CONTAINER_CACHE_DIR}/login/with-the-same-user.sh"

DOCKER_ENV+=(
  --env THIS_BUILD_USER="$(id -u -n)"
  --env THIS_BUILD_UID="$(id -u)"
  --env THIS_BUILD_GROUP="$(id -g -n)"
  --env THIS_BUILD_GID="$(id -g)"
  --env THIS_BUILD_HOME="${CONTAINER_USER_HOME}"
  --env https_proxy="http://10.0.13.122:3128"
  --env HTTPS_PROXY="http://10.0.13.122:3128"
  --env http_proxy="http://10.0.13.122:3128"
  --env HTTP_PROXY="http://10.0.13.122:3128"
  --env all_proxy="socks5://10.0.13.122:3128"
  --env ALL_PROXY="socks5://10.0.13.122:3128"
)

DOCKER_MOUNT+=(
  --volume "${CONTAINER_CACHE_DIR}/login:/login"
  --volume "${CONTAINER_CACHE_DIR}/${CONTAINER_USER_HOME}/.local:${CONTAINER_USER_HOME}/.local"
)

DOCKER_PUBLISH+=(
  "--publish" "$(get_random_port):22"
)

DOCKER_CMD=(docker run
  ${OPTIONS[@]+"${OPTIONS[@]}"}
  ${DOCKER_ENV[@]+"${DOCKER_ENV[@]}"}
  ${DOCKER_MOUNT[@]+"${DOCKER_MOUNT[@]}"}
  ${DOCKER_PUBLISH[@]+"${DOCKER_PUBLISH[@]}"}
  ${IMAGE[@]+"${IMAGE[@]}"}
  bash --login /login/with-the-same-user.sh
  ${COMMAND_ARGS[@]+"${COMMAND_ARGS[@]}"}
)

echo ""
echo ${DOCKER_CMD[@]+"${DOCKER_CMD[@]}"}
echo ""

${DOCKER_CMD[@]+"${DOCKER_CMD[@]}"}
