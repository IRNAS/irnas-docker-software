# Irnas's repository for Zephyr Docker images

This repository contains images that are used for building the various Zephyr projects.

## Available images

### vanilla-zephyr

This image is based on the official Zephyr image and contains the Zephyr SDK and Python dependencies
to build Zephyr applications.

The `vanilla-zepyhr` folder contains two Dockerfiles:

- `Dockerfile.ci` - A docker image which contains all tools needed to build Zephyr applications.
  This image is suitable to be used in the CI. From Zephyr SDK it contains the following toolchains:
  - `arm-zepyhr-eabi` - used for building applications for ARM Cortex-M.
  - `x86_64-zephyr-elf` - used for building applications for `native_sim` board.
- `Dockerfile.dev` - A docker image which inherits from `Dockerfile.ci` image and contains some
  configuration to make development inside the container easier.

#### Naming scheme

This images adhere to the following naming scheme:

```code
ghcr.io/irnas/vanilla-zephyr-<zephyr-version>-<image-type>:<tag>
```

Where:

- `<zephyr-version>` - Zephyr version that the image is based on, eg. `v3.6.0`, `v3.7.0`, etc.
- `<image-type>` - Type of the image, either `ci`, `dev`.
- `<tag>` - Tag of the image, eg. `latest`, `v1.0.0`, `v1.0.1` etc.

### ncs-zephyr

This image is based on the Nordic's nRFUtil toolchain-manager binary that provides the environment
for build NCS applications. to build Zephyr applications.

The `ncs-zepyhr` folder contains only a single Dockerfile with two multi-stage builds:

- `CI` - A docker image which contains all tools needed to build NCS applications. This image is
  suitable to be used in the CI.
- `DEV` - A docker image which inherits from `CI` stage. It contains flashing tools and some
  configuration to make development inside the container easier.
- `ZSH` - A docker image which inherits from `DEV` stage. It contains ZSH shell and some other tools
  for nicer developer experience.

<!-- prettier-ignore -->
> [!WARNING]
> Using the `CI` image to create a container in the GitHub Actions workflow it is mandatory to
> change the default shell to `bash -l {0}` by modifying the `default.run.shell` field. The shell
> must be login shell to source the environment variables correctly, otherwise the installed tools
> inside the image won't be available.

<!-- prettier-ignore -->
> [!WARNING]
> Some runners, like the ones provided by GitHub (`ubuntu-latest`, et al.), have a specific bug
> related to the location of the `.nrfutil` folder. The full explanation of the bug can be found
> in [this issue]. TLDR: Run `cp -r /root/.nrfutil $HOME` as the first command after checkout
> action, `nrfutil` will then work as expected.

[this issue]: https://github.com/IRNAS/irnas-docker-software/issues/9

#### Naming scheme

This images adhere to the following naming scheme:

```code
ghcr.io/irnas/ncs-zephyr-<ncs-version>-<image-type>:<tag>
```

Where:

- `<ncs-version>` - NCS version that the image uses, eg. `v2.6.0`, `v2.7.0`, etc.
- `<image-type>` - Type of the image, either `ci`, `dev`.
- `<tag>` - Tag of the image, eg. `latest`, `v1.0.0`, `v1.0.1` etc.

## Using pre-built images

To run pre-built images, you need to have [Docker Engine] installed on your machine. If you don't
mind additional Docker programs you can instead install [Docker Desktop] application which includes
Docker Engine.

[Docker Engine]: https://docs.docker.com/engine/
[Docker Desktop]: https://docs.docker.com/desktop/

<!-- prettier-ignore -->
> [!NOTE]
> Docker should be configured to run without `sudo`. Follow the [official docs] on how to setup that.

[official docs]:
  https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user

Once Docker engine is installed, you can pull the image with the `docker pull` command. Docker
images are available on the [GitHub Container registry]. Click on one of the images to see the exact
pull command, for example:

```bash
docker pull ghcr.io/irnas/vanilla-zephyr-v3.6.0-dev:latest
```

[GitHub Container registry]: https://github.com/orgs/IRNAS/packages?repo_name=irnas-docker-software

Once the image is pulled, you can run it as a container with the following command:

```bash
docker run -it --rm \
    --privileged \
    --volume <path_to_projects_top_westdir>:/home/user/workdir \
    --volume /dev:/dev \
    --workdir /home/user/workdir \
    --device-cgroup-rule='c 166:* rmw' \
    <full image name>
```

Do not forget to replace `<path_to_projects_top_westdir>` with the path to the top directory of your
Zephyr project and `<full image name>` with the full image name you pulled.

## Development

Images can be built with the help of the build scripts located in individual image folders:

```bash
./build_ci.sh
./build_dev.sh
```

There is a accompanying `run.sh` script that can be used to run the image.

## MacOS support

Images currently do not support MacOS, users are required to build them locally. Workarounds is
described in the [issue].

[issue]: https://github.com/IRNAS/irnas-docker-software/issues/3#issuecomment-2273196922

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
