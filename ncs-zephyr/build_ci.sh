#! /usr/bin/env bash
NCS_SDK_VERSION=v2.6.1

docker build \
	--build-arg "ZEPHYR_VERSION=$NCS_SDK_VERSION" \
	-f "Dockerfile" \
	--target ci \
	--platform linux/amd64 \
	-t "irnas/ncs-zephyr-$NCS_SDK_VERSION-ci:latest" .
