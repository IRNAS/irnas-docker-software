#! /usr/bin/env bash
ZEPHYR_VERSION=v3.6.0
MCUBOOT_VERSION=a4eda30f5b0cfd0cf15512be9dcd559239dbfc91
BASE_IMAGE="irnas/vanilla-zephyr-ci-$ZEPHYR_VERSION:latest"

docker build \
    --build-arg "ZEPHYR_VERSION=$ZEPHYR_VERSION" \
    --build-arg "MCUBOOT_VERSION=$MCUBOOT_VERSION" \
    --build-arg "BASE_IMAGE=$BASE_IMAGE" \
    -f "Dockerfile.dev" \
    -t "irnas/vanilla-zephyr-dev-$ZEPHYR_VERSION:latest" .
