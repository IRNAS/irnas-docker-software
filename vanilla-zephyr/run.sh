#! /usr/bin/env bash
# Usage: run.sh west_top_dir
#
# Description:
#   The provided west_top_dir is mounted into the container and the container
#   is started in interactive mode. The user can then run the commands in the
#   container.
#
# Arguments:
#
#   west_top_dir        The path to the west top directory. This directory is
#                       is always the parent directory of the project directory.

NUM_ARGS=1
# Print help text and exit if -h, or --help or insufficient number of arguments
# was given.
if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ $# -lt ${NUM_ARGS} ]; then
    sed -ne '/^#/!q;s/.\{1,2\}//;1d;p' <"$0"
    exit 1
fi
docker run -it \
    --privileged \
    --workdir /home/user/workdir \
    --volume "${1}":/home/user/workdir \
    --volume /dev:/dev \
    --device-cgroup-rule='c 166:* rmw' \
    irnas/vanilla-zephyr-v3.6.0-dev:latest
