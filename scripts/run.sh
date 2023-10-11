#!/bin/bash
set -e
echo ""
echo ""
echo "============== ${APP} ======================"
echo ""
RENDER_ID=$(getent group render | cut -d: -f3)

PARENT_COMMAND=$(tr -d '\0' < /proc/$PPID/cmdline)
suffix="_pull.sh"
if [[ $PARENT_COMMAND == *$suffix ]]; then
  echo "Pulling ${APP} container ...."
  DOCKER_BUILDKIT=1 RENDER_ID=$RENDER_ID docker-compose -f docker-compose.yml up -d
else
  echo "Building ${APP} image ...."
  DOCKER_BUILDKIT=1 RENDER_ID=$RENDER_ID docker-compose -f docker-compose-build.yml up -d
fi

PORT=$(docker inspect ${APP}_rocmyai561 | grep HostPort | sort | uniq | grep -o [0-9]* | head)
GREEN="\e[32m"
ENDCOLOR="\e[0m"

echo ""
echo "${APP} container started ..."
echo "attaching to container with: docker exec -it ${APP}_rocmyai561 bash" 
echo ""
echo "You can now run ${APP} inside the container with:"
echo -e $(printf "${GREEN}${COMMAND_APP}${ENDCOLOR}")
echo ""
echo "Then open ${APP} webui at:"
echo -e $(printf "${GREEN}http://localhost:$PORT${ENDCOLOR}")
echo "(ignore further messages mentionning port 7860)"
echo ""
echo "ubuntu user/password: ai/ai"
echo ""
echo "repo: $REPO"
echo "docker repo: $DOCKER_REPO"
echo ""
echo "====== container output: ======"
echo ""
docker exec -it ${APP}_rocmyai561 bash
#xdg-open "http://localhost:$PORT"

