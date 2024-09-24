ARG NCS_SDK_VERSION

##############
# Base image #
##############
FROM ubuntu:22.04 AS base

# Stages building from base inherit below env vars.
ENV EAST_DONT_USE_TOOLCHAIN_MANAGER=1
ENV EAST_CODECHECKER_CI_MODE=1

# OS dependencies and packages
# gcc-multilib make = Host tools for native_sim build
# python 3.8 is installed by some older NCS versions hence older version of
# libffi is required.
RUN \
  apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y install --no-install-recommends \
  wget curl unzip lcov gcc-multilib make ca-certificates ssh doxygen \
  graphviz librsvg2-bin texlive-latex-base texlive-latex-extra latexmk libffi7 \
  texlive-fonts-recommended imagemagick mscgen software-properties-common \
  && wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc \
  && add-apt-repository "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-18 main" \
  && apt-get -y install --no-install-recommends clang-18 clang-tidy-18 clangd-18 cppcheck \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Create simlink for clang-*, otherwise Codechecker and VSCode fails to
# find them.
RUN ln -s /usr/bin/clang-tidy-18 /usr/bin/clang-tidy && \
    ln -s /usr/bin/clang-18 /usr/bin/clang && \
    ln -s /usr/bin/clangd-18 /usr/bin/clangd

############
# CI image #
############
FROM base AS ci

ARG NCS_SDK_VERSION
ARG NRFUTIL_VERSION=7.11.1
ARG TOOLCHAIN_MANAGER_VERSION=0.15.0
ARG CODECHECKER_VERSION=6.23.1

SHELL [ "/bin/bash", "-euxo", "pipefail", "-c" ]

# NCS SDK
RUN \
  wget https://developer.nordicsemi.com/.pc-tools/nrfutil/x64-linux/nrfutil \
  && chmod +x nrfutil \
  && mv nrfutil /usr/bin \
  && nrfutil self-upgrade --to-version $NRFUTIL_VERSION \
  && nrfutil install toolchain-manager=$TOOLCHAIN_MANAGER_VERSION \
  && nrfutil toolchain-manager install --ncs-version ${NCS_SDK_VERSION} \
  && rm -fr /root/ncs/tmp \
  && rm -fr /root/ncs/downloads

# Install all Python dependencies.
RUN <<EOT
    mngr() {
        nrfutil toolchain-manager launch -- $@
    }

    # Install yq, a lightweight and portable command-line YAML processor
    wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O yq
    chmod +x yq

    # Get the SDK Zephyr version from the sdk-nrf's west.yml file
    SDK_ZEPHYR_VERSION=$(wget -O - \
    https://raw.githubusercontent.com/nrfconnect/sdk-nrf/$NCS_SDK_VERSION/west.yml \
    | ./yq '.manifest.projects[] | select(.repo-path == "sdk-zephyr") | .revision')

    # Install Python packages and doc requirements. If first sdk-zephyr link fails, try the second.
    mngr pip install --no-cache-dir east-tool pre-commit codechecker==$CODECHECKER_VERSION
    mngr pip install --no-cache-dir -r \
    https://raw.githubusercontent.com/nrfconnect/sdk-zephyr/$SDK_ZEPHYR_VERSION/doc/requirements.txt || \
    mngr pip install --no-cache-dir -r https://raw.githubusercontent.com/nrfconnect/sdk-zephyr/$SDK_ZEPHYR_VERSION/scripts/requirements-doc.txt
    rm ./yq
EOT

SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["nrfutil", "toolchain-manager", "launch", "--shell"]

#############
# Dev image #
#############

FROM base AS dev

ARG UID=1000
ARG GID=1000

ARG arch=amd64
ARG NORDIC_COMMAND_LINE_TOOLS_VERSION="10-24-2/nrf-command-line-tools-10.24.2"

SHELL [ "/bin/bash", "-euxo", "pipefail", "-c" ]

# Install Nordic command line tools
# Releases: https://www.nordicsemi.com/Products/Development-tools/nrf-command-line-tools/download
RUN <<EOT
    NCLT_BASE=https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-command-line-tools/sw/versions-10-x-x
    echo "Host architecture: $arch"
    NCLT_URL="${NCLT_BASE}/${NORDIC_COMMAND_LINE_TOOLS_VERSION}_linux-${arch}.tar.gz"
    echo "NCLT_URL=${NCLT_URL}"
    if [ ! -z "$NCLT_URL" ]; then
        mkdir -p temporary && cd temporary
        wget -qO - "${NCLT_URL}" | tar --no-same-owner -xz
        # Install included JLink
        mkdir /opt/SEGGER
        tar xzf JLink_*.tgz -C /opt/SEGGER
        mv /opt/SEGGER/JLink* /opt/SEGGER/JLink
        # Install nrf-command-line-tools
        cp -r ./nrf-command-line-tools /opt
        ln -s /opt/nrf-command-line-tools/bin/nrfjprog /usr/local/bin/nrfjprog
        ln -s /opt/nrf-command-line-tools/bin/mergehex /usr/local/bin/mergehex
        cd ..
        rm -rf temporary
    else
        echo "Skipping nRF Command Line Tools (not available for $arch)" ;
    fi
EOT

# Add JLink binaries to the PATH
ENV PATH="$PATH:/opt/SEGGER/JLink"

# Create 'user' account
RUN useradd -l -m -s /bin/bash -u $UID user


# Copy nrfutil binary and ncs folder with toolchain from the CI image.
# Changing ownership to 'user' here is critical due to 2 reasons:
# - without that 'user' won't be able to access nrfutil and ncs
# - If chown is done in the next step, the image size will increase by
#   the size of the nrfutil and ncs folder.
COPY --from=ci --chown=user:user /usr/bin/nrfutil /usr/bin/nrfutil
COPY --from=ci --chown=user:user /root/.nrfutil /home/user/.nrfutil
COPY --from=ci --chown=user:user /root/ncs /home/user/ncs


# All shebangs of the python binaries currently point to the original location
# of the installed interpreter, which is under /root/ncs/toolchains/.
# If this is unchanged, not a single python package works.
# The solution is to change the shebangs of all python binaries to
# '#!/usr/bin/env python'.
# If any specific Python version errors are encountered, is probably just best
# to repeat the nrfutil toolchain installation, instead of copying it from the
# CI stage.
RUN find /home/user/ncs/toolchains/ -path '**/usr/local/bin/*' | \
    grep -v '__pycache__' | \
    xargs -I {} sh -c "sed -i '1 s|.*root/ncs/toolchains.*python.*|#\!/usr/bin/env python|g' {}"

# Make 'user' default on launch
USER user

SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["nrfutil", "toolchain-manager", "launch", "--shell"]
