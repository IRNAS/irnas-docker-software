#! /usr/bin/env bash
ZEPHYR_VERSION=v4.3.0
ZEPHYR_SDK_VERSION=0.17.4
MCUBOOT_VERSION=96576b341ee19f1c3af6622256b0d4f3d408e1e3

docker build \
    --build-arg "ZEPHYR_VERSION=$ZEPHYR_VERSION" \
    --build-arg "ZEPHYR_SDK_VERSION=$ZEPHYR_SDK_VERSION" \
    --build-arg "MCUBOOT_VERSION=$MCUBOOT_VERSION" \
    -f "Dockerfile.ci" \
    -t "irnas/vanilla-zephyr-$ZEPHYR_VERSION-ci:latest" .
