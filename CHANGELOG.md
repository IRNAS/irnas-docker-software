# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## [Unreleased]

## [1.17.0] - 2025-08-19

### Added

- Add support for NCS v3.1.0 and Zephyr v4.2.0.

## [1.16.0] - 2025-07-09

No changes in this release, the Docker images were rebuilt to use the latest East version.

## [1.15.3] - 2025-07-07

### Changed

- Pin `nrfutil device` to `2.12.2`.

## [1.15.2] - 2025-07-07

### Fixed

- Debugging commands (west debug/west attach) in the ncs-zephyr will now correctly locate the JLink
  binaries.
- Resolve issue with the gdb-py.

## [1.15.1] - 2025-05-30

### Fixed

- Actually pin `nrfutil device` to `2.11.2`, previous release didn't pin it correctly.

## [1.15.0] - 2025-05-28

### Changed

- Pin `nrfutil device` to `2.11.2`.

## [1.14.0] - 2025-05-20

### Added

- Add `zip` to the ncs-zephyr and vanilla-zephyr Docker images.

## [1.13.0] - 2025-05-19

### Added

- Add support for NCS v3.0.0 and v3.0.1.

## [1.12.0] - 2025-04-18

### Added

- Use newer version of the JLink (v8.18). Newer version is needed due to the XIP features.

### Changed

- Change to using `EAST_NRFUTIL_CI_MODE` instead of `EAST_DONT_USE_TOOLCHAIN_MANAGER`. See
  [East's release notes](https://github.com/IRNAS/irnas-east-software/releases/tag/v0.27.0) for
  details.
- Pin `nrfutil` to `8.0.0`.
- Pin `nrfutil device` to `2.9.0`.

## [1.11.2] - 2025-04-11

No changes in this release, the Docker images were rebuilt to use the latest East version.

## [1.11.1] - 2025-04-11

No changes in this release, the Docker images were rebuilt to use the latest East version.

## [1.11.0] - 2025-03-14

### Added

- Add support for Zephyr v4.1.0.

### Change

- Infra: Update versions of 3rd-party actions, move to `ubuntu-latest`.

### Fix

- Pin pygobject pip package to 3.50.0 in vanilla-zephyr/Dockerfile.ci. Before that the latest
  version was installed, which caused the image build to fail.

## [1.10.0] - 2024-12-20

### Added

- Add support for Zephyr v3.7.1 (LTS) and v4.0.0.
- Add support for NCS v2.9.0

## [1.9.0] - 2024-11-20

### Added

- Add bash completion to the Dev ncs-zephyr docker image.

## [1.8.1] - 2024-11-19

This is a no-change release, it is only needed so that image with NCS v2.8.0 can be published.

## [1.8.0] - 2024-11-07

### Added

- Add `git` to the ncs-zephyr CI image.

## [1.7.0] - 2024-10-25

### Added

- Add `minicom` to the ncs-zephyr Docker image.
- Make the `ncs-zephyr` Docker images suitable for use in the GitHub Actions. The default shell
  needs to be set to `bash -l {0}` to source the environment variables correctly. See warning in the
  README.md for more information.

## [1.6.0] - 2024-10-11

### Added

- `zsh` image-type to the ncs-zephyr Docker image. This image-type is based on the `dev`and contains
  ZSH shell and some other tools for nicer developer experience.

### Changed

- ncs-zephyr Docker image now adds environment variables of the toolchain-manager to the bashrc file
  to provide access to the installed tools. Previously that was done by the `ENTRYPOINT` command,
  however that approach didn't always work with VSCode's Dev Containers.

## [1.5.0] - 2024-09-24

### Added

- Add `vim`, `nano` and `tmux` to the ncs-zephyr Docker image.
- Add `jq` to both ncs-zephyr and vanilla-zephyr Docker images, as IRNAS's projects depend on it.
  @Finwood found the missing dependency and contributed a fix in #5.

### Fixed

- Add missing clangd symlink in ncs-zephyr.

## [1.4.1] - 2024-08-23

### Added

All below changes are related to the ncs-zephyr Docker image:

- Support for building the documentation with the Sphinx documentation tool.
- Support for running Codechecker and various static analysis tools: clangsa, clang-tidy and
  cppcheck.
- Support for clangd language server, useful for code navigation and completion inside VSCode's dev
  container.

## [1.3.2] - 2024-08-16

### Removed

- `linux/arm64` build for vanilla-zephyr Docker image.

### Fixed

- Fix the upload of the Docker image to the GitHub Container Registry.

## [1.3.1] - 2024-08-14

### Added

- ssh program to the ncs-zephyr Dockerfile.

## [1.2.0] - 2024-08-02

## [1.1.0] - 2024-07-12

### Added

- OpenOCD into vanilla Zephyr Dev Dockerfile.

## [1.0.1] - 2024-07-09

### Fixed

- Fixed publish workflow for vanilla Zephyr Dev image.

## [1.0.0] - 2024-07-05

### Added

- Vanilla Zephyr Dockerfiles and publish workflows.

[unreleased]: https://github.com/IRNAS/irnas-docker-software/compare/v1.17.0...HEAD
[1.17.0]: https://github.com/IRNAS/irnas-docker-software/compare/v1.16.0...v1.17.0
[1.16.0]: https://github.com/IRNAS/irnas-docker-software/compare/v1.15.3...v1.16.0
[1.15.3]: https://github.com/IRNAS/irnas-docker-software/compare/v1.15.2...v1.15.3
[1.15.2]: https://github.com/IRNAS/irnas-docker-software/compare/v1.15.1...v1.15.2
[1.15.1]: https://github.com/IRNAS/irnas-docker-software/compare/v1.15.0...v1.15.1
[1.15.0]: https://github.com/IRNAS/irnas-docker-software/compare/v1.14.0...v1.15.0
[1.14.0]: https://github.com/IRNAS/irnas-docker-software/compare/v1.13.0...v1.14.0
[1.13.0]: https://github.com/IRNAS/irnas-docker-software/compare/v1.12.0...v1.13.0
[1.12.0]: https://github.com/IRNAS/irnas-docker-software/compare/v1.11.2...v1.12.0
[1.11.2]: https://github.com/IRNAS/irnas-docker-software/compare/v1.11.1...v1.11.2
[1.11.1]: https://github.com/IRNAS/irnas-docker-software/compare/v1.11.0...v1.11.1
[1.11.0]: https://github.com/IRNAS/irnas-docker-software/compare/v1.10.0...v1.11.0
[1.10.0]: https://github.com/IRNAS/irnas-docker-software/compare/v1.9.0...v1.10.0
[1.9.0]: https://github.com/IRNAS/irnas-docker-software/compare/v1.8.1...v1.9.0
[1.8.1]: https://github.com/IRNAS/irnas-docker-software/compare/v1.8.0...v1.8.1
[1.8.0]: https://github.com/IRNAS/irnas-docker-software/compare/v1.7.0...v1.8.0
[1.7.0]: https://github.com/IRNAS/irnas-docker-software/compare/v1.6.0...v1.7.0
[1.6.0]: https://github.com/IRNAS/irnas-docker-software/compare/v1.5.0...v1.6.0
[1.5.0]: https://github.com/IRNAS/irnas-docker-software/compare/v1.4.1...v1.5.0
[1.4.1]: https://github.com/IRNAS/irnas-docker-software/compare/v1.3.2...v1.4.1
[1.3.2]: https://github.com/IRNAS/irnas-docker-software/compare/v1.3.1...v1.3.2
[1.3.1]: https://github.com/IRNAS/irnas-docker-software/compare/v1.2.0...v1.3.1
[1.2.0]: https://github.com/IRNAS/irnas-docker-software/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/IRNAS/irnas-docker-software/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/IRNAS/irnas-docker-software/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/IRNAS/irnas-docker-software/compare/b08044e0137bcbbf5f060545de6b2d2a9f1ee8d8...v1.0.0
