#! /usr/bin/env bash
NCS_SDK_VERSION=v2.6.0

docker build \
	--build-arg "NCS_SDK_VERSION=$NCS_SDK_VERSION" \
	--target dev \
	-f "Dockerfile" \
	-t "irnas/ncs-zephyr-$NCS_SDK_VERSION-dev:latest" .
