NODE_VERSION := 18.4

IMAGE_NAME := hidori/ja-chrome-node
IMAGE_TAG := node$(NODE_VERSION)

.PHONY: build
build:
	docker build \
		--build-arg NODE_VERSION=$(NODE_VERSION) \
		-f ./Dockerfile --tag $(IMAGE_NAME):$(IMAGE_TAG) .
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(IMAGE_NAME):latest

.PHONY: run
run:
	docker run -it --rm --privileged $(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: push
push:
	docker push -a $(IMAGE_NAME)
