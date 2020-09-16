#!/bin/bash

VERSION=noop

if [ $EVENT = "schedule" ]; then
VERSION=nightly
elif [[ $GITHUB_REF == refs/tags/* ]]; then
VERSION=${GITHUB_REF#refs/tags/}
elif [[ $GITHUB_REF == refs/heads/* ]]; then
VERSION="$(echo ${GITHUB_REF#refs/heads/} | sed -r 's#/+#-#g')"
if [ "$DEFAULT_BRANCH" = "$VERSION" ]; then
    VERSION=edge
fi
elif [[ $GITHUB_REF == refs/pull/* ]]; then
VERSION=pr-$EVENT_NUMBER
fi
TAGS="${DOCKER_IMAGE}:${VERSION}"
if [[ $VERSION =~ ^v[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
MINOR=${VERSION%.*}
MAJOR=${MINOR%.*}
TAGS="$TAGS,${DOCKER_IMAGE}:${MINOR},${DOCKER_IMAGE}:${MAJOR},${DOCKER_IMAGE}:latest"
elif [ "${{ github.event_name }}" = "push" ]; then
TAGS="$TAGS,${DOCKER_IMAGE}:sha-${GITHUB_SHA::8}"
fi
echo ::set-output name=version::"${VERSION}"
echo ::set-output name=tags::"${TAGS}"
echo ::set-output name=created::"$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
