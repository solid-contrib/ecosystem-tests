#!/bin/bash
set -e

function setup {
  echo Branch name: $1
  docker network create testnet
  docker build -t server --build-arg BRANCH=$1 tests/bookmarks/docker/server
  docker build -t cookie tests/bookmarks/docker/cookie
  docker run -d --env-file tests/bookmarks/server-env.list --name server --network=testnet -w /node-solid-server server /node-solid-server/bin/solid-test start --config-file /node-solid-server/config.json
  docker run -d --env-file tests/bookmarks/thirdparty-env.list --name thirdparty --network=testnet -v `pwd`/tests/bookmarks:/surface server /node-solid-server/bin/solid-test start --config-file /surface/thirdparty-config.json
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
runTests webid-provider-tests v2.0.3
runTests solid-crud-tests v6.0.0
waitForNss thirdparty
runTests web-access-control-tests v7.1.0
teardown

# To debug, e.g. running web-access-control-tests jest interactively,
# comment out `teardown` and uncomment this instead:
# env
# docker run -it --network=testnet \
#     --env COOKIE="$COOKIE_server" \
#     --env COOKIE_ALICE="$COOKIE_server" \
#     --env COOKIE_BOB="$COOKIE_thirdparty" \
#     --env-file tests/bookmarks/web-access-control-tests-env.list \
#   solidtestsuite/web-access-control-tests:latest /bin/bash
