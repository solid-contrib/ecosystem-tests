#!/bin/bash
set -e

function setup {
  echo Branch name: $1
  docker network create testnet
  docker build -t server --build-arg BRANCH=$1 tests/bookmarks/docker/server
  docker build -t cookie tests/bookmarks/docker/cookie
  docker build -t launcher tests/bookmarks/docker/launcher
  docker build -t markbook --build-arg REPO=https://github.com/michielbdejong/markbook tests/bookmarks/docker/static
  docker run -d --env-file tests/bookmarks/server-env.list --name server --network=testnet -w /node-solid-server server /node-solid-server/bin/solid-test start --config-file /node-solid-server/config.json
  docker run -d --env-file tests/bookmarks/thirdparty-env.list --name thirdparty --network=testnet -w /node-solid-server -v `pwd`/tests/bookmarks:/surface server /node-solid-server/bin/solid-test start --config-file /surface/thirdparty-config.json
  docker run -d --network=testnet --name launcher -v /Users/michiel/gh/pdsinterop/launcher-exploration/:/app -p 3000:3000 launcher
  docker run -d --network=testnet --name markbook -p 3001:3000 markbook
}
function teardown {
  docker stop `docker ps --filter network=testnet -q`
  docker rm `docker ps --filter network=testnet -qa`
  docker network remove testnet
}

function waitForNss {
  docker pull solidtestsuite/webid-provider-tests
  until docker run --rm --network=testnet solidtestsuite/webid-provider-tests curl -kI https://$1 2> /dev/null > /dev/null
  do
    echo Waiting for $1 to start, this can take up to a minute ...
    docker ps -a
    docker logs $1
    sleep 1
  done

  docker logs $1
  echo Getting cookie for $1...
  export COOKIE_$1="`docker run --cap-add=SYS_ADMIN --network=testnet --env-file tests/bookmarks/$1-env.list cookie`"
}

function runTests {
  docker pull solidtestsuite/$1:$2
  
  echo "Running $1 against server with cookie $COOKIE_server"
  docker run --rm --network=testnet \
    --env COOKIE="$COOKIE_server" \
    --env COOKIE_ALICE="$COOKIE_server" \
    --env COOKIE_BOB="$COOKIE_thirdparty" \
    --env-file tests/bookmarks/$1-env.list solidtestsuite/$1:$2
}

# ...
teardown || true
#setup $1
setup latest-passing-solid-test-suite
waitForNss server
# runTests webid-provider-tests v2.0.3
# runTests solid-crud-tests v6.0.0
# waitForNss thirdparty
# runTests web-access-control-tests v7.1.0
echo NSS is running
echo "starting firefox tester"
docker run --detach --name=firefox          --network=testnet -p 5800:5800  --shm-size 2g jlesage/firefox:latest
echo starting VNC and Cypress
ENV_ROOT=$(pwd)
export ENV_ROOT=${ENV_ROOT}

##################
### VNC Server ###
##################

# remove previous x11 unix socket file, avoid any problems while mounting new one.
rm -rf "${ENV_ROOT}/temp/.X11-unix"

# try to change DISPLAY_WIDTH, DISPLAY_HEIGHT to make it fit in your screen,
# NOTE: please do not commit any change related to resolution.
docker run --detach --network=testnet                                         \
  --name=vnc-server                                                           \
  -p 5700:8080                                                                \
  -e RUN_XTERM=no                                                             \
  -e DISPLAY_WIDTH=1920                                                       \
  -e DISPLAY_HEIGHT=1080                                                      \
  -v "${ENV_ROOT}/temp/.X11-unix:/tmp/.X11-unix"                              \
  theasp/novnc:latest

###############
### Cypress ###
###############

# create cypress and attach its display to the VNC server container. 
# this way you can view inside cypress container through vnc server.
docker run --detach --network=testnet                                         \
  --name="cypress.docker"                                                     \
  -e DISPLAY=vnc-server:0.0                                                   \
  -v "${ENV_ROOT}/tests/bookmarks/docker/tls:/tls"                            \
  -v "${ENV_ROOT}/tests/bookmarks/cypress:/bookmarks"                         \
  -v "${ENV_ROOT}/temp/.X11-unix:/tmp/.X11-unix"                              \
  -w /bookmarks                                                               \
  --entrypoint cypress                                                        \
  cypress/included:13.3.0                                                     \
  open --project .

# print instructions.
clear
echo "Now browse to :"
echo "Firefox inside VNC Server -> http://localhost:5800"
echo "Cypress inside VNC Server -> http://localhost:5700"
echo ""
echo "FIXME: logging in to http://markbook:3000 fails"
echo "See https://github.com/solid-contrib/ecosystem-tests/pull/3#issuecomment-2015198406"
echo "Credentials:"custom provider: https://server / username: alice / password: test123"
# teardown

# To debug, e.g. running web-access-control-tests jest interactively,
# comment out `teardown` and uncomment this instead:
# env
# docker run -it --network=testnet \
#     --env COOKIE="$COOKIE_server" \
#     --env COOKIE_ALICE="$COOKIE_server" \
#     --env COOKIE_BOB="$COOKIE_thirdparty" \
#     --env-file tests/bookmarks/web-access-control-tests-env.list \
#   solidtestsuite/web-access-control-tests:latest /bin/bash
