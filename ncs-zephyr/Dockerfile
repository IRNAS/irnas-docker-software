# OS dependencies and packages
# gcc-multilib make = Host tools for native_sim build
# python 3.8 is installed by toolchain manager hence older version of libffi is
# required. This argument is used in both images, that's why it's defined here.
ARG APT_PACKAGES="wget curl unzip lcov gcc-multilib make libffi7 ca-certificates ssh"

############
# CI image #
############
FROM ubuntu:22.04 AS ci

ARG NCS_SDK_VERSION=v2.6.0
ARG NRFUTIL_VERSION=7.11.1
ARG TOOLCHAIN_MANAGER_VERSION=0.15.0
ARG APT_PACKAGES

RUN \
  apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y install --no-install-recommends \
  $APT_PACKAGES \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

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

#############
# Dev image #
#############

FROM ubuntu:22.04 AS dev

ARG UID=1000
ARG GID=1000

ARG arch=amd64
ARG NORDIC_COMMAND_LINE_TOOLS_VERSION="10-24-2/nrf-command-line-tools-10.24.2"
ARG APT_PACKAGES

SHELL [ "/bin/bash", "-euxo", "pipefail", "-c" ]

RUN \
  apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y install --no-install-recommends \
  $APT_PACKAGES \
  git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Nordic command line tools
# Releases: https://www.nordicsemi.com/Products/Development-tools/nrf-command-line-tools/download
RUN <<EOT
    NCLT_BASE=https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-command-line-tools/sw/versions-10-x-x
    echo "Host architecture: $arch"
    case $arch in
        "amd64")
            NCLT_URL="${NCLT_BASE}/${NORDIC_COMMAND_LINE_TOOLS_VERSION}_linux-amd64.tar.gz"
            ;;
        "arm64")
            NCLT_URL="${NCLT_BASE}/${NORDIC_COMMAND_LINE_TOOLS_VERSION}_linux-arm64.tar.gz"
            ;;
    esac
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

# Make 'user' default on launch
USER user

RUN nrfutil toolchain-manager launch -- pip install --no-cache-dir east-tool pre-commit

SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["nrfutil", "toolchain-manager", "launch", "--shell"]
