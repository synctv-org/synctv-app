# syntax=docker/dockerfile:1.7

# Use the builder's native platform so the Flutter SDK can run on both amd64
# and arm64. The generated web bundle is architecture-neutral, so it can be
# copied into amd64 and arm64 nginx runtime images below.
FROM --platform=$BUILDPLATFORM ubuntu:24.04 AS web-build

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      unzip \
      xz-utils \
    && rm -rf /var/lib/apt/lists/*

ARG FLUTTER_VERSION=3.44.8
RUN git clone --depth 1 --branch "$FLUTTER_VERSION" \
      https://github.com/flutter/flutter.git /opt/flutter

ENV PATH="/opt/flutter/bin:${PATH}" \
    FLUTTER_ROOT="/opt/flutter"
RUN flutter --version \
    && flutter config --no-analytics \
    && flutter precache --web

WORKDIR /app

ARG SYNCTV_BUILT_IN_SERVER_URL=
ARG SYNCTV_OPTIMIZATION_LEVEL=4
ARG SYNCTV_SOURCE_MAPS=0
ARG SYNCTV_WEB_RESOURCES_CDN=1
ARG SYNCTV_BASE_HREF=

COPY pubspec.yaml pubspec.lock .metadata l10n.yaml analysis_options.yaml ./
COPY lib ./lib
COPY assets ./assets
COPY web ./web
COPY packages ./packages
COPY tool/build_web.sh ./tool/build_web.sh

RUN flutter pub get --enforce-lockfile && \
    SYNCTV_BUILT_IN_SERVER_URL="$SYNCTV_BUILT_IN_SERVER_URL" \
    SYNCTV_OPTIMIZATION_LEVEL="$SYNCTV_OPTIMIZATION_LEVEL" \
    SYNCTV_SOURCE_MAPS="$SYNCTV_SOURCE_MAPS" \
    SYNCTV_WEB_RESOURCES_CDN="$SYNCTV_WEB_RESOURCES_CDN" \
    SYNCTV_BASE_HREF="$SYNCTV_BASE_HREF" \
    SYNCTV_SKIP_PUB=1 \
    ./tool/build_web.sh

# Dependabot keeps the nginx 1.27-alpine tag and digest in sync. Keep the
# digest pinned here so builds stay reproducible until an update PR is merged.
FROM nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10

ENV SYNCTV_BACKEND_URL=http://synctv:8080
ENV NGINX_PORT=8080
ENV NGINX_CLIENT_MAX_BODY_SIZE=200m

COPY --from=web-build /app/build/web /usr/share/nginx/html
COPY deploy/nginx.conf.template /etc/nginx/templates/default.conf.template

EXPOSE 8080
