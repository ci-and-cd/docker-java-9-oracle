#!/usr/bin/env bash

set -e

docker version
docker-compose version

WORK_DIR=$(pwd)

if [ -n "${CI_OPT_DOCKER_REGISTRY_PASS}" ] && [ -n "${CI_OPT_DOCKER_REGISTRY_USER}" ]; then
    echo ${CI_OPT_DOCKER_REGISTRY_PASS} | docker login --password-stdin -u="${CI_OPT_DOCKER_REGISTRY_USER}" docker.io
fi

IMAGE_NAME=${IMAGE_PREFIX:-cirepo}/java-9-oracle
export IMAGE_TAG=${IMAGE_ARG_JAVA9_VERSION:-9.0.4}
if [ "${TRAVIS_BRANCH}" != "master" ]; then export IMAGE_TAG=${IMAGE_TAG}-SNAPSHOT; fi

docker-compose build
docker-compose push

if [ "${TRAVIS_BRANCH}" == "master" ] && [ "${IMAGE_TAG}" == "${IMAGE_TAG_LATEST}" ]; then
    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
    docker push ${IMAGE_NAME}:latest
fi
