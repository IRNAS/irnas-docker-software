#! /usr/bin/env bash
ZEPHYR_VERSION=v3.6.0
MCUBOOT_VERSION=a4eda30f5b0cfd0cf15512be9dcd559239dbfc91

docker build \
    --build-arg "ZEPHYR_VERSION=$ZEPHYR_VERSION" \
    --build-arg "MCUBOOT_VERSION=$MCUBOOT_VERSION" \
    -f "Dockerfile.ci" \
    -t "irnas/vanilla-zephyr-$ZEPHYR_VERSION-ci:latest" .
