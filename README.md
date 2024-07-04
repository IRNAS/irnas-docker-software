# Irnas's repository for Zephyr Docker images

This repository contains images that are used for building the Zephyr projects. Dockerfiles that are
used to build images are divided into folders, where each folder represents a set of specific
images.

## Docker images

### Vanilla Zephyr

This image is based on the official Zephyr image and contains the Zephyr SDK and Python dependencies
to build Zephyr applications.

The `vanilla-zepyhr` folder contains two Dockerfiles:

- `Dockerfile.ci` - A docker image which contains all tools needed to build Zephyr applications.
  From Zephyr SDK toolchains it contains the following:
  - `arm-zepyhr-eabi` - used for building applications for ARM Cortex-M.
  - `x86_64-zephyr-elf` - used for building applications for `native_sim` board. This image is
    suitable to be used in the CI.
- `Dockerfile.dev` - A docker image which inherits from `Dockerfile.ci` image and contains some
  configuration to make development inside the container easier.

#### Building images

Both images can be built with the help of the build scripts:

```bash
cd vanilla-zephyr
./build_ci.sh
./build_dev.sh
```

#### Developing Zephyr applications inside the containers

A development container can be started with the following command:

```bash
cd vanilla-zephyr
./run.sh <path-to-top-west-dir>
```

## Making a new release

Take the following steps to make a new release:

1. Make sure that `Unreleased` section in the `CHANGELOG.md` is populated with relevant new
   additions.
2. Go under `Actions` tab and select `Create a new release` section in the left sidebar.
3. Click `Run workflow` button on the right and write in the version tag that you want to make a
   release for.

After that:

- the new GitHub release will be created and
- CI will build all configured Zephyr images and push them to our public [Container registry].

[Container registry]: https://github.com/orgs/IRNAS/packages
