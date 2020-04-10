#!/usr/bin/env bash

PROJECT_ROOT=$( cd `dirname $0`/..; pwd)
export newVersion=$1
[[ -z $newVersion ]] && echo "Version not provided" && exit 1

echo PROECT_ROOT=$PROJECT_ROOT
pushd $PROJECT_ROOT

./mvnw versions:set \
  -DnewVersion=${newVersion} \
  -DgenerateBackupPoms=false

./mvnw clean -B -P release install

gpg --homedir $MAVEN_GNUPGHOME --verify target/*.pom.asc

./mvnw clean -B -P release deploy

docker build \
  -t yogendra/api-demo:${newVersion} \
  -t yogendra/api-demo:latest \
  --build-arg JAR_FILE=target/api-demo-${newVersion}.jar \
  .


docker push yogendra/api-demo:${newVersion}
docker push yogendra/api-demo:latest

git add .
git commit -m "Release ${newVersion}"
git tag ${newVersion}
git push
git push --tags

popd