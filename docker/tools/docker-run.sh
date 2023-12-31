#!/usr/bin/env bash

set -e
set -u
set -o pipefail

# usage: bash docker-run.sh [OPTIONS] IMAGE [COMMAND] [ARG...]

function get_valid_port() {
  local random_port
  random_port="$((RANDOM % (49151 - 1024 + 1) + 1024))"
  if [ -n "$(command -v netstat)" ]; then
    while netstat -tuln | grep -q ":${random_port}"; do
      random_port="$((RANDOM % (49151 - 1024 + 1) + 1024))"
    done
  fi
  echo "${random_port}"
}

OPTIONS=()
IMAGE=()
COMMAND_ARGS=()

while ((${#})); do
  repository_tag="$(docker inspect --format "{{index .RepoTags 0}}" "${1}" 2>/dev/null || true)"
  if [ -z "${repository_tag}" ] || [[ "${1}" =~ ^[0-9]+$ ]] || [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    OPTIONS+=("${1}")
    shift 1
  else
    IMAGE+=("${repository_tag}")
    shift 1
    COMMAND_ARGS+=("${@}")
    break
  fi
done

if [ -n "${IMAGE[*]+"NOT EMPTY"}" ]; then
  CONTAINER_HOME="/${USER}"
  HOST_CACHE_DIR="${HOME}/.docker_cache/$(docker images --format "{{.ID}}" "${IMAGE[*]}")"

  mkdir -p "${HOST_CACHE_DIR}/login"
  mkdir -p "${HOST_CACHE_DIR}/${CONTAINER_HOME}/.local"
  if [ -d "${HOME}/.ssh" ]; then cp -rf "${HOME}/.ssh" "${HOST_CACHE_DIR}/${CONTAINER_HOME}/"; fi
  if [ -f "${HOME}/.gitconfig" ]; then cp -f "${HOME}/.gitconfig" "${HOST_CACHE_DIR}/${CONTAINER_HOME}/"; fi
  mkdir -p "${HOST_CACHE_DIR}/${CONTAINER_HOME}/.go/bin"
  mkdir -p "${HOST_CACHE_DIR}/${CONTAINER_HOME}/.go/pkg"
  mkdir -p "${HOST_CACHE_DIR}/${CONTAINER_HOME}/.go/src"

  echo "
#!/usr/bin/env bash

set -e

COMMAND_ARGS=(\"\${@}\")

mkdir -p /login

{
  set -x
  for shell in zsh fish bash sh; do
    [ -n \"\$(command -v \"\${shell}\")\" ] && custom_shell=\"\$(command -v \"\${shell}\")\" && break
  done

  useradd -ms \"\${custom_shell-\"/bin/sh\"}\" -d \"\${THIS_BUILD_HOME}\" \"\${THIS_BUILD_USER}\"
  usermod -aG sudo \"\${THIS_BUILD_USER}\"
  echo \"\${THIS_BUILD_USER}\":\"\${THIS_BUILD_USER}\" | chpasswd
  usermod -u \"\${THIS_BUILD_UID}\" \"\${THIS_BUILD_USER}\"
  groupmod -g \"\${THIS_BUILD_GID}\" \"\${THIS_BUILD_GROUP}\" || true

  for config in /root/.vim /root/.vimrc /root/.bashrc /root/.zshrc /root/.zprofile /root/.oh-my-zsh /root/.tmux.conf; do
    [ -e \"\${config}\" ] && cp -rf \"\${config}\" \"\${THIS_BUILD_HOME}\"/
  done

  chown -R \"\${THIS_BUILD_USER}\":\"\${THIS_BUILD_USER}\" \"\${THIS_BUILD_HOME}\"

  service ssh start || true
  set +x
} 1>/login/login.log 2>&1

sudo -u \"#\${THIS_BUILD_UID}\" --preserve-env HOME=\"\${THIS_BUILD_HOME}\" PYTHONPATH=\"\${PYTHONPATH}\" PATH=\"\${THIS_BUILD_HOME}/.local/bin:\${GOPATH}/bin:\${PATH}\" \"\${COMMAND_ARGS[@]}\"

" >"${HOST_CACHE_DIR}/login/with-the-same-user.sh"

  DOCKER_ENV+=(
    --env THIS_BUILD_USER="$(id -u -n)"
    --env THIS_BUILD_UID="$(id -u)"
    --env THIS_BUILD_GROUP="$(id -g -n)"
    --env THIS_BUILD_GID="$(id -g)"
    --env THIS_BUILD_HOME="${CONTAINER_HOME}"
    --env https_proxy="http://10.0.13.122:3128"
    --env HTTPS_PROXY="http://10.0.13.122:3128"
    --env http_proxy="http://10.0.13.122:3128"
    --env HTTP_PROXY="http://10.0.13.122:3128"
    --env all_proxy="socks5://10.0.13.122:3128"
    --env ALL_PROXY="socks5://10.0.13.122:3128"
    --env GOPATH="${CONTAINER_HOME}/.go"
  )

  DOCKER_MOUNT+=(
    --volume "${HOST_CACHE_DIR}/login:/login"
    --volume "${HOST_CACHE_DIR}/${CONTAINER_HOME}/.local:${CONTAINER_HOME}/.local"
    --volume "${HOST_CACHE_DIR}/${CONTAINER_HOME}/.ssh:${CONTAINER_HOME}/.ssh"
    --volume "${HOST_CACHE_DIR}/${CONTAINER_HOME}/.gitconfig:${CONTAINER_HOME}/.gitconfig"
    --volume "${HOST_CACHE_DIR}/${CONTAINER_HOME}/.go:${CONTAINER_HOME}/.go"
  )

  DOCKER_PUBLISH+=(
    --publish "$(get_valid_port):22"
  )

  DOCKER_LOGIN+=(
    bash --login /login/with-the-same-user.sh
  )
fi

DOCKER_CMD=(docker run
  ${OPTIONS[@]+"${OPTIONS[@]}"}
  ${DOCKER_ENV[@]+"${DOCKER_ENV[@]}"}
  ${DOCKER_MOUNT[@]+"${DOCKER_MOUNT[@]}"}
  ${DOCKER_PUBLISH[@]+"${DOCKER_PUBLISH[@]}"}
  ${IMAGE[@]+"${IMAGE[@]}"}
  ${DOCKER_LOGIN[@]+"${DOCKER_LOGIN[@]}"}
  ${COMMAND_ARGS[@]+"${COMMAND_ARGS[@]}"}
)

echo -e "\033[7m"
echo -e ${DOCKER_CMD[@]+"${DOCKER_CMD[@]}"}
echo -e "\033[0m"

${DOCKER_CMD[@]+"${DOCKER_CMD[@]}"}
