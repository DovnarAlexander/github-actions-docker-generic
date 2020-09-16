#!/bin/bash

VERSION=noop

if [ "$EVENT" = "schedule" ]
then
    VERSION=nightly
elif [[ $GITHUB_REF == refs/tags/* ]]
then
    VERSION=${GITHUB_REF#refs/tags/}
elif [[ $GITHUB_REF == refs/heads/* ]]
then
    VERSION=$(echo "${GITHUB_REF#refs/heads/}" | sed -r 's#/+#-#g')
    if [ "$DEFAULT_BRANCH" = "$VERSION" ]
    then
        VERSION=latest
    fi
elif [[ $GITHUB_REF == refs/pull/* ]]
then
    VERSION=pr-$GITHUB_EVENT_PATH
fi

TAGS="${VERSION}"
if [[ $VERSION =~ ^v[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
then
    MINOR=${VERSION%.*}
    MAJOR=${MINOR%.*}
    TAGS="$TAGS,${MINOR},${MAJOR},RC"
elif [ "$EVENT" = "push" ]
then
    TAGS="$TAGS,:sha-${GITHUB_SHA::8}"
fi

echo ::set-output name=version::"${VERSION}"
echo ::set-output name=tags::"${TAGS}"
echo ::set-output name=created::"$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
