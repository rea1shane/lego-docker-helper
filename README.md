# Lego Docker helper

Make [Lego](https://github.com/go-acme/lego) deploy certs in Docker easier.

No changes were made other than installing `docker-cli` and [`helper.sh`](https://github.com/rea1shane/lego-docker-helper/blob/main/helper.sh) on the original image. See [Dockerfile](https://github.com/rea1shane/lego-docker-helper/blob/main/Dockerfile).

Features:

- Use `crond` as daemon.
- Provide some useful functions:
  - Copy certs to containers with specified Docker label.
  - Execute command in containers with specified Docker label.
  - Restart containers with specified Docker label.

See a demo of the functions in [example](https://github.com/rea1shane/lego-docker-helper/tree/main/example).

## Usage

First, Mount `docker.sock` with `rw` permission to lego-docker-helper container, like [this](https://github.com/rea1shane/lego-docker-helper/blob/main/example/docker-compose.yaml#L6).

Second, Add labels to target containers, like [this](https://github.com/rea1shane/lego-docker-helper/blob/main/example/docker-compose.yaml#L12).

Finally, do everything else as use Lego before.
