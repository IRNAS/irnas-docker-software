#! /usr/bin/env bash
NCS_SDK_VERSION=v3.0.2

docker build \
    --build-arg "NCS_SDK_VERSION=$NCS_SDK_VERSION" \
    --target zsh \
    -f "Dockerfile" \
    -t "irnas/ncs-zephyr-$NCS_SDK_VERSION-zsh:latest" .
