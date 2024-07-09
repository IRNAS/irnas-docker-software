#! /usr/bin/env bash
NCS_SDK_VERSION=v2.6.0

docker build \
	--build-arg "ZEPHYR_VERSION=$NCS_SDK_VERSION" \
	-f "Dockerfile" \
	--target ci \
	-t "irnas/ncs-zephyr-$NCS_SDK_VERSION-ci:latest" .
