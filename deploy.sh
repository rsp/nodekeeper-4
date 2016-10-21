#!/bin/bash

skip() {
    echo "Skipping deployment" $1; exit 0
}

n=`node -e 'console.log(require("./index").name)'`
v=`node -e 'console.log(require("./index").version)'`
echo "Deployment of $n@$v"

[ "$TRAVIS" == true ] || skip "not in Travis"
[ "$TRAVIS_REPO_SLUG" == rsp/$n ] || skip "in repo $TRAVIS_REPO_SLUG"
[ "$TRAVIS_BRANCH" == master ] || skip "on branch $TRAVIS_BRANCH"

u=https://registry.npmjs.org/$n/$v
s=`curl -s -o /dev/null -w "%{http_code}" $u`
echo "$u ($s)"
if [ "$s" == 200 ]; then
  echo "$n@$v is already published"
  exit 0
elif [ "$s" == 404 ]; then
  echo "Publishing $n@$v ..."
  echo "//registry.npmjs.org/:_authToken=$NPMTOKEN" > ~/.npmrc
  npm publish
else
  echo "Unexpected registry status code: $s"
  exit 1
fi
