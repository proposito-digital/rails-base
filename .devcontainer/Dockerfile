ARG RUBY_VERSION=3.4.8
FROM ghcr.io/rails/devcontainer/images/ruby:${RUBY_VERSION}

LABEL MAINTAINER="Diogo Caetano <diogo@proposito.digital>"

# set user to root to install dependencies
USER root

# Install linux updates and dependencies for Rails development
RUN set -eux \
&& apt-get update \
&& apt-get install -y --no-install-recommends \
curl unzip ca-certificates \
build-essential libpq-dev libnotify-bin xosd-bin nano wget \
libnss3 libatk-bridge2.0-0 libgtk-3-0 libgbm1 libasound2 \
libxkbcommon0 libxcomposite1 libxdamage1 libxrandr2 xdg-utils\
&& rm -rf /var/lib/apt/lists/*

# set user back to vscode
USER vscode