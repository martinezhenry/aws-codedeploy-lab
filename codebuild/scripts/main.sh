#!/usr/bin/env bash

BASEDIR=$(dirname "$0")
source "$BASEDIR"/functions.sh
source "$BASEDIR"/unit_test.sh

function build_env() {
  branch=$1
  register_log "validating branch $branch"

  if [ -f ./target/classes/project.properties ]
  then
    mvn resources:resources
    BUILD_ID=$(date +'%y%m%d%H%M%S')
    VERSION=$(cat ./target/classes/project.properties | grep "version" | cut -d'=' -f2 || exit)
    IMAGE_NAME=$(cat ./target/classes/project.properties | grep "artifactId" | cut -d'=' -f2 || exit)
  else
    register_log "File './target/classes/project.properties' not exists"
    exit 1
  fi
  IMAGE_TAG="$VERSION"
  if [ "$branch" == "develop" ]
  then
    IMAGE_TAG="$VERSION.$BUILD_ID"
  fi
  export IMAGE_TAG
  export IMAGE_NAME
  export BUILD_ID
  export VERSION

  register_log "Environments: "
  register_log "IMAGE_NAME=$IMAGE_NAME"
  register_log "IMAGE_TAG=$IMAGE_TAG"
  register_log "VERSION=$VERSION"
  register_log "BUILD_ID=$BUILD_ID"

}


function steps() {
    branch=$1
    if [ "$branch" == "develop" ]
    then
      build_env "$branch"
      run_junit_test "$branch"
    fi
}


steps "develop"