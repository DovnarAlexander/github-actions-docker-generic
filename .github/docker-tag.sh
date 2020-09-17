#!/bin/bash

VERSION=latest

if [ -n "$AUTO_TAG" ]
then
    VERSION="${AUTO_TAG}"
elif [ -n "$RELEASE" ]
then
    VERSION="${RELEASE}"
elif [ -n "$TAG" ]
then
    VERSION="${TAG}"
fi

echo ::set-output name=tag::"${VERSION}"
