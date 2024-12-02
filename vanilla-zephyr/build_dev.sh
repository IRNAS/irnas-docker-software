#! /usr/bin/env bash
ZEPHYR_VERSION=v3.7.1
ZEPHYR_SDK_VERSION=0.16.9
MCUBOOT_VERSION=ea2410697dd0262edec041a0ccb07fdbde7c1aff
BASE_IMAGE="irnas/vanilla-zephyr-$ZEPHYR_VERSION-ci:latest"

docker build \
    --build-arg "ZEPHYR_VERSION=$ZEPHYR_VERSION" \
    --build-arg "ZEPHYR_SDK_VERSION=$ZEPHYR_SDK_VERSION" \
    --build-arg "MCUBOOT_VERSION=$MCUBOOT_VERSION" \
    --build-arg "BASE_IMAGE=$BASE_IMAGE" \
    -f "Dockerfile.dev" \
    -t "irnas/vanilla-zephyr-$ZEPHYR_VERSION-dev:latest" .
