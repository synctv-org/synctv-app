#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install --yes --no-install-recommends \
  clang \
  cmake \
  libasound2-dev \
  libepoxy-dev \
  libgtk-3-dev \
  liblzma-dev \
  libmpv-dev \
  libsoup-3.0-dev \
  libwebkit2gtk-4.1-dev \
  ninja-build \
  pkg-config
