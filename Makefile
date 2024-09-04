LEGO_TAG = latest

APP_NAME = lego-docker-helper

DOCKER_REPO = rea1shane
DOCKER_IMAGE_NAME = $(APP_NAME)

.PHONY: build
build:
	docker build --build-arg LEGO_TAG=$(LEGO_TAG) -t $(DOCKER_REPO)/$(DOCKER_IMAGE_NAME):$(LEGO_TAG) .
