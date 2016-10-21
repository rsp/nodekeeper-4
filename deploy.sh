#!/bin/sh
n=`node -e 'console.log(require("./index").name)'`
v=`node -e 'console.log(require("./index").version)'`
u=https://registry.npmjs.org/$n/$v
s=`curl -s -o /dev/null -w "%{http_code}" $u`
if [ "$s" == 200 ]; then
  echo "$n@$v is already published"
  exit 0
elif [ "$s" == 404 ]; then
  echo "Unexpected registry status code: $s"
  exit 1
else
  echo "Publishing $n@$v ..."
fi
