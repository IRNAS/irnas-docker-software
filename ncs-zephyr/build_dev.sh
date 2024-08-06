#! /usr/bin/env bash
NCS_SDK_VERSION=v2.6.1

docker build \
	--build-arg "NCS_SDK_VERSION=$NCS_SDK_VERSION" \
	--target dev \
	-f "Dockerfile" \
	--platform linux/amd64 \
	-t "irnas/ncs-zephyr-$NCS_SDK_VERSION-dev:latest" .
