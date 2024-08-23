# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## [Unreleased]

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

[unreleased]: https://github.com/IRNAS/irnas-docker-software/compare/v1.3.2...HEAD
[1.3.2]: https://github.com/IRNAS/irnas-docker-software/compare/v1.3.1...v1.3.2
[1.3.1]: https://github.com/IRNAS/irnas-docker-software/compare/v1.2.0...v1.3.1
[1.2.0]: https://github.com/IRNAS/irnas-docker-software/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/IRNAS/irnas-docker-software/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/IRNAS/irnas-docker-software/compare/v1.0.0...v1.0.1
[1.0.0]:
  https://github.com/IRNAS/irnas-docker-software/compare/b08044e0137bcbbf5f060545de6b2d2a9f1ee8d8...v1.0.0
