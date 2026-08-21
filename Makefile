.DEFAULT_GOAL := dev

# Reverse proxy listen port for the local web app.
PROXY_PORT ?= $(if $(SYNCTV_PROXY_PORT),$(SYNCTV_PROXY_PORT),8081)
# Flutter web-server device port.
APP_PORT ?= $(if $(SYNCTV_APP_PORT),$(SYNCTV_APP_PORT),8083)
# SyncTV backend that the reverse proxy forwards /api and /ws to.
API_UPSTREAM ?= $(if $(SYNCTV_API_UPSTREAM),$(SYNCTV_API_UPSTREAM),http://localhost:8080)
# Built-in server URL embedded into web builds. Empty by default so the
# web bundle ships server-neutral; set SYNCTV_BUILT_IN_SERVER_URL to embed one.
BUILT_IN_SERVER_URL ?= $(SYNCTV_BUILT_IN_SERVER_URL)
# Output directory for flutter build web.
BUILD_OUTPUT ?= $(if $(SYNCTV_BUILD_OUTPUT),$(SYNCTV_BUILD_OUTPUT),build/web)
# Flutter run/build mode: release, debug, or profile.
RUN_MODE ?= $(if $(SYNCTV_RUN_MODE),$(SYNCTV_RUN_MODE),release)
# Web build optimization level passed to dart compile js.
OPTIMIZATION_LEVEL ?= $(if $(SYNCTV_OPTIMIZATION_LEVEL),$(SYNCTV_OPTIMIZATION_LEVEL),4)
# Emit source maps for the web build.
SOURCE_MAPS ?= $(if $(SYNCTV_SOURCE_MAPS),$(SYNCTV_SOURCE_MAPS),0)
# Serve Flutter/Dart web resources from a CDN.
WEB_RESOURCES_CDN ?= $(if $(SYNCTV_WEB_RESOURCES_CDN),$(SYNCTV_WEB_RESOURCES_CDN),1)
# Optional <base href> for web builds.
BASE_HREF ?= $(if $(SYNCTV_BASE_HREF),$(SYNCTV_BASE_HREF),)
# Docker image repository used by docker-build.
DOCKER_IMAGE ?= noelorin/synctv-flutter-web
# Skip flutter pub get during web builds.
SKIP_PUB ?= $(if $(SYNCTV_SKIP_PUB),$(SYNCTV_SKIP_PUB),1)

.PHONY: dev build docker-build help

# Run the single-bundle Flutter web app behind the local reverse proxy.
dev:
	SYNCTV_PROXY_PORT="$(PROXY_PORT)" \
	SYNCTV_APP_PORT="$(APP_PORT)" \
	SYNCTV_API_UPSTREAM="$(API_UPSTREAM)" \
	SYNCTV_RUN_MODE="$(RUN_MODE)" \
	./dev-web.sh

# Build the Flutter web bundle with optional embedded server URL.
build:
	SYNCTV_BUILT_IN_SERVER_URL="$(BUILT_IN_SERVER_URL)" \
	SYNCTV_BUILD_OUTPUT="$(BUILD_OUTPUT)" \
	SYNCTV_OPTIMIZATION_LEVEL="$(OPTIMIZATION_LEVEL)" \
	SYNCTV_SOURCE_MAPS="$(SOURCE_MAPS)" \
	SYNCTV_WEB_RESOURCES_CDN="$(WEB_RESOURCES_CDN)" \
	SYNCTV_BASE_HREF="$(BASE_HREF)" \
	SYNCTV_SKIP_PUB="$(SKIP_PUB)" \
	./tool/build_web.sh

# Build Flutter Web inside Docker and tag the image locally.
docker-build:
	docker build -t "$(DOCKER_IMAGE):local" .

help:
	@printf 'Usage: make <target> [VAR=value ...]\n\n'
	@printf 'Targets:\n'
	@printf '  dev          Run the single-bundle Flutter web app behind the reverse proxy\n'
	@printf '  build        Build the Flutter web bundle\n'
	@printf '  docker-build Build Flutter Web inside Docker and tag a local image\n'
	@printf '  help         Show this help\n'
	@printf '\nKey variables:\n'
	@printf '  PROXY_PORT=8081            Reverse proxy listen port\n'
	@printf '  APP_PORT=8083              Flutter web-server port\n'
	@printf '  API_UPSTREAM=http://...    SyncTV backend forwarded for /api and /ws\n'
	@printf '  BUILT_IN_SERVER_URL=...    Embedded server URL (empty: server-neutral)\n'
	@printf '  RUN_MODE=release|debug|profile  Flutter run mode for make dev\n'
	@printf '  DOCKER_IMAGE=...           Docker repository used by docker-build\n'
