#! /usr/bin/env bash
ZEPHYR_VERSION=v3.7.1
ZEPHYR_SDK_VERSION=0.16.9
MCUBOOT_VERSION=ea2410697dd0262edec041a0ccb07fdbde7c1aff

docker build \
    --build-arg "ZEPHYR_VERSION=$ZEPHYR_VERSION" \
    --build-arg "ZEPHYR_SDK_VERSION=$ZEPHYR_SDK_VERSION" \
    --build-arg "MCUBOOT_VERSION=$MCUBOOT_VERSION" \
    -f "Dockerfile.ci" \
    -t "irnas/vanilla-zephyr-$ZEPHYR_VERSION-ci:latest" .
