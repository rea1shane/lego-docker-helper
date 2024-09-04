APP_NAME = lego-docker-helper

DOCKER_REPO = rea1shane
DOCKER_IMAGE_NAME = $(APP_NAME)

.PHONY: build
build:
	docker build -t $(DOCKER_REPO)/$(DOCKER_IMAGE_NAME) .
