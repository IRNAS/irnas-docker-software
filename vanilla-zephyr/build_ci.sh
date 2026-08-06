#! /usr/bin/env bash
ZEPHYR_VERSION=v4.4.0
ZEPHYR_SDK_VERSION=1.0.1
MCUBOOT_VERSION=ee39e2d694bd827ffd1bebbce2f571a9154e6ec2

docker build \
    --build-arg "ZEPHYR_VERSION=$ZEPHYR_VERSION" \
    --build-arg "ZEPHYR_SDK_VERSION=$ZEPHYR_SDK_VERSION" \
    --build-arg "MCUBOOT_VERSION=$MCUBOOT_VERSION" \
    -f "Dockerfile.ci" \
    -t "irnas/vanilla-zephyr-$ZEPHYR_VERSION-ci:latest" .
