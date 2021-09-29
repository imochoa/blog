IMGNAME := jojomi/hugo:0.85.0

# Auto variables
DATE := $(shell date)
CURRENT_UID := $(shell id -u)
CURRENT_GID := $(shell id -g)
COMMIT_HASH := $(shell git rev-parse HEAD | cut -c1-8)
INTERACTIVE := $(shell [ -t 0 ] && echo 1)
export INTERACTIVE

# Host paths
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
REPO_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
TMP_DIR := ${REPO_DIR}/tmp
PUBLIC_DIR := ${REPO_DIR}/public
STATIC_DIR := ${REPO_DIR}/static
IMG_DIR := ${STATIC_DIR}/img
LOGO_IMG_DIR := ${STATIC_DIR}/img/logo

.PHONY: clean-public
clean-public:
	sudo rm -rf "${PUBLIC_DIR}/"*


.PHONY: chown-public
chown-public:
	sudo chown -R $${USER}:$${USER} "${PUBLIC_DIR}"


.PHONY: submodule-update
submodule-update:
	git submodule update --recursive --remote

.PHONY: submodule-sync
submodule-sync:
	git submodule sync

.PHONY: hugo
hugo: clean-public
	docker run                    \
		--rm                        \
		--volume "${REPO_DIR}":/src \
		${IMGNAME}                  \
		hugo --source="/src"

.PHONY: hugo-server
hugo-server: clean-public
	docker run                    \
		--rm                        \
		--volume "${REPO_DIR}":/src \
		-p 1313:1313                \
		${IMGNAME}                  \
		hugo server --source="/src" --bind="0.0.0.0"


.PHONY: build-img
build-img:
	docker build                               \
		-f ${PROVISION_DIR}/Dockerfile   \
		--build-arg CODE_DIR=${DOCKER_CODE_DIR} \
		-t ${IMGNAME}:${COMMIT_HASH}          \
		${REPO_DIR}

.PHONY: list-imgs
list-imgs:
	docker images ${IMGNAME}

.PHONY: clean-curr-img
clean-curr-img:
	docker image rm ${IMGNAME}:${COMMIT_HASH}

.PHONY: clean-imgs
clean-imgs:
	docker images ${IMGNAME} --format "{{.Tag}}" | xargs -I{} docker image rm ${IMGNAME}:{}

.PHONY: help
help:
	cat Makefile

render-pngs:
	echo "Using" \
	&& inkscape -w 16 -h 16 -e ${LOGO_IMG_DIR}/16.png ${LOGO_IMG_DIR}/logo.svg \
	&& inkscape -w 32 -h 32 -e ${LOGO_IMG_DIR}/32.png ${LOGO_IMG_DIR}/logo.svg \
	&& inkscape -w 48 -h 48 -e ${LOGO_IMG_DIR}/48.png ${LOGO_IMG_DIR}/logo.svg \
	&& inkscape -w 64 -h 64 -e ${LOGO_IMG_DIR}/64.png ${LOGO_IMG_DIR}/logo.svg \
	&& convert ${LOGO_IMG_DIR}/64.png  -background white \
          \( -clone 0 -resize 16x16 -extent 16x16 \) \
          \( -clone 0 -resize 32x32 -extent 32x32 \) \
          \( -clone 0 -resize 48x48 -extent 48x48 \) \
          \( -clone 0 -resize 64x64 -extent 64x64 \) \
          -delete 0 -alpha off -colors 256 ${LOGO_IMG_DIR}/favicon.ico

