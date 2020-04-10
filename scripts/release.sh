#!/usr/bin/env bash

PROJECT_ROOT=$( cd `dirname $0`/..; pwd)
echo PROECT_ROOT=$PROJECT_ROOT
pushd $PROJECT_ROOT
export newVersion=$1

./mvnw versions:set \
  -DnewVersion=${newVersion} \
  -DgenerateBackupPoms=false

./mvnw clean -B -P release install

gpg --verify target/*.pom.asc

./mvnw clean -B P release deploy

docker build -t yogendra/api-demo:${newVersion} -t yogendra/api-demo:latest --build-arg target/api-demo-${newVersion}.jar .
docker push yogendra/api-demo:${newVersion}
docker push yogendra/api-demo:latest

git add .
git commit -m "Release ${newVersion}"
git tag ${newVersion}
git push --tags

popd