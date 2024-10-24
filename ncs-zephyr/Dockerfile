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
  wget curl unzip lcov jq gcc-multilib make ca-certificates ssh doxygen \
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

# Append environment variables of the toolchain-manager to the user's bashrc
# and /etc/profile to get access to the installed programs.
#
# Previously that was done with the ENTRYPOINT command, however that is a bit
# error prone for devcontainer usecases, as it isn't always taken into account.
#
# The reason that we need to append to both to some rc file and /etc/profile is
# is that the rc file gets sourced when a interactive shell is started (like
# when you run docker run -it), but /etc/profile is sourced when a non-interactive
# login shell is started. This solves the GitHub Action workflow issue where
# which always runs the command in a non-interactive shell. By setting the
# defaults.run.shell property to "bash -l {0}" the /etc/profile file is sourced,
# thus we get access to the path.
RUN nrfutil toolchain-manager env --as-script sh >> ~/.bashrc
RUN nrfutil toolchain-manager env --as-script sh >> /etc/profile

#############
# Dev image #
#############

FROM base AS dev

ARG UID=1000
ARG GID=1000

ARG arch=amd64
ARG NORDIC_COMMAND_LINE_TOOLS_VERSION="10-24-2/nrf-command-line-tools-10.24.2"

SHELL [ "/bin/bash", "-euxo", "pipefail", "-c" ]

# Install some editor and utility tools.
RUN \
  apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y install --no-install-recommends vim nano tmux minicom \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*


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

# Append environment variables of the toolchain-manager to the user's bashrc
# to get access to the installed programs.
# See extra info at the above similar line.
RUN nrfutil toolchain-manager env --as-script sh >> ~/.bashrc

#############
# ZSH image #
#############

FROM dev AS zsh

USER root

# Install some utility tools.
RUN \
  apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y install --no-install-recommends git zsh \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && wget -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - | tar xz \
  && chmod +x eza \
  && mv eza /usr/local/bin/eza \
  && chsh -s $(which zsh)

USER user

RUN <<EOT
mkdir -p ~/.zsh
git clone https://github.com/sindresorhus/pure.git ~/.zsh/pure
curl -L git.io/antigen > ~/.zsh/antigen.zsh
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

cat >> ~/.zshrc << EOF
# Install plugin manager and plugins
source $HOME/.zsh/antigen.zsh
antigen bundle agkozak/zsh-z
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle hcgraf/zsh-sudo
antigen bundle zsh-users/zsh-syntax-highlighting # Needs to be last bundle
antigen apply

# Setup pure prompt
fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure
zstyle :prompt:pure:git:stash show yes

# Change the path color
zstyle :prompt:pure:user color cyan
zstyle :prompt:pure:host color cyan

setopt histignoredups   # Ignore command history duplicates
setopt menu_complete    # Tab completion when choice ambiguous

# Aliases
alias ls='eza'
alias cp="cp -i"        # confirm before overwriting something
alias df='df -h'        # human-readable sizes
alias free='free -m'    # show sizes in MB
alias ll='ls -aglh --color=auto --group-directories-first'
alias ml='minicom'
alias cl='rm -fr build'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Fzf
source <(fzf --zsh)
EOF

EOT


# Append environment variables of the toolchain-manager to the user's zshrc
# to get access to the installed programs.
# See extra info at the above similar line.
RUN nrfutil toolchain-manager env --as-script sh >> ~/.zshrc

# Execute the file so that plugins are installed.
RUN zsh ~/.zshrc

CMD [ "/bin/zsh" ]
