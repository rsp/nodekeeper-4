#!/bin/bash

n=`node -e 'console.log(require("./index").name)'`
v=`node -e 'console.log(require("./index").version)'`
echo "Deployment of $n@$v"

[ "$TRAVIS" == true ] || (echo "Skipping deployment" && exit 1)
[ "$TRAVIS_REPO_SLUG" == rsp/$name ] || (echo "Skipping deployment in repo $TRAVIS_REPO_SLUG" && exit 0)
[ "$TRAVIS_BRANCH" == master ] || (echo "Skipping deployment on branch $TRAVIS_BRANCH" && exit 0)

u=https://registry.npmjs.org/$n/$v
s=`curl -s -o /dev/null -w "%{http_code}" $u`
echo "$u ($s)"
if [ "$s" == 200 ]; then
  echo "$n@$v is already published"
  exit 0
elif [ "$s" == 404 ]; then
  echo "Unexpected registry status code: $s"
  exit 1
else
  echo "Publishing $n@$v ..."
fi
