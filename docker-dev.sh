#!/usr/bin/env bash

PROJECT_NAME=${PWD##*/}

docker run \
  -it \
  --name "${PROJECT_NAME}_$(date +'%H%M%S')" \
  -v $PROJECT_NAME:/workspace/$PROJECT_NAME \
  gitpod/workspace-full
