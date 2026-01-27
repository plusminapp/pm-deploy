#!/usr/bin/env bash

stage=$(echo "$2" | tr '[:upper:]' '[:lower:]')
echo stage: $stage
source .env
source "${stage}/${stage}".env

if [ "$stage" == "dev" ]; then
  VERSION=${PM_DEV_VERSION}
elif [ "$stage" == "stg" ]; then
  VERSION=${PM_STG_VERSION}
else
  echo "Invalid environment: $stage"
  exit 1
fi

echo version: $VERSION

docker save -o .images/pm-$1.${VERSION}.tar plusmin/pm-$1:${VERSION}
scp .images/pm-$1.${VERSION}.tar box:~/pm/.images/
ssh box "bash -lc 'docker load -i ~/pm/.images/pm-$1.${VERSION}.tar'"

