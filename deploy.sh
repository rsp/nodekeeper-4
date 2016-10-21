#!/bin/bash

npm_config="spin=false progress=false color=false"

echo "Starting travis-npm-publish-branch"
echo -e "Using npm config:\n${npm_config// /\n}"

skip() {
  echo "Skipping deployment" $1; exit 0
}
commands() {
  for c in $@; do
    command -v $c >/dev/null 2>&1 || skip "without $c"
  done
}

commands node npm curl
[ -f ~/.npmrc-bak ] && skip "with ~/.npmrc-bak already present"
[ -f package.json ] || skip "without package.json"
n=`node -e 'console.log(require("./package.json").name)'`
v=`node -e 'console.log(require("./package.json").version)'`
echo "Deployment of $n@$v"
[ "$TRAVIS" == true ] || skip "not in Travis"
[ "$TRAVIS_REPO_SLUG" == rsp/$n ] || skip "in repo $TRAVIS_REPO_SLUG"
[ "$TRAVIS_BRANCH" == master ] || skip "on branch $TRAVIS_BRANCH"
[ "$NPM_AUTH" == "" ] && skip "without NPM_AUTH"

u=https://registry.npmjs.org/$n/$v
s=`curl -s -o /dev/null -w "%{http_code}" $u`
echo "$u ($s)"
if [ "$s" == 200 ]; then
  echo "$n@$v is already published"
  exit 0
elif [ "$s" == 404 ]; then
  echo "Publishing $n@$v ..."
  [ -f ~/.npmrc ] && mv -v ~/.npmrc ~/.npmrc-bak
  echo -e "${npm_config// /\n}\n$NPM_AUTH" > ~/.npmrc
  npm publish
  rm -fv ~/.npmrc
  [ -f ~/.npmrc ] && mv -v ~/.npmrc-bak ~/.npmrc
else
  echo "Unexpected registry status code: $s"
  exit 1
fi
