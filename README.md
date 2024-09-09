# [Lego](https://github.com/go-acme/lego) Docker helper

Use Docker label to determine which certs should be deployed to which containers and deploy them via the Docker client.

No changes were made other than installing `docker-cli` and [`helper.sh`](https://github.com/rea1shane/lego-docker-helper/blob/main/helper.sh) on the original image. See [Dockerfile](https://github.com/rea1shane/lego-docker-helper/blob/main/Dockerfile).

Features:

- Use `crond` as daemon.
- Provide some useful functions ([demo](https://github.com/rea1shane/lego-docker-helper/tree/main/demo)):
  - Copy certs to containers with specified Docker label.
  - Execute command in containers with specified Docker label.
  - Restart containers with specified Docker label.

> [!IMPORTANT]
>
> The time zone inside the container is UTC, modify your cron expression according to your time zone.

> [!TIP]
>
> Edit cron jobs via `crontab -e` to ensure that `crond` can be reloaded.

## Usage

First, adding labels to containers where certs need to be deployed, like [this](https://github.com/rea1shane/lego-docker-helper/blob/main/demo/docker-compose.yaml#L11). Down and up them to make labels effect.

Second, write your own hook script, like [this](https://github.com/rea1shane/lego-docker-helper/blob/main/hook.sh.example).

Then, up lego-docker-helper container and mount `docker.sock` in it with `rw` permission, like [this](https://github.com/rea1shane/lego-docker-helper/blob/main/demo/docker-compose.yaml#L6). Also don't forget to mount your hook script into the container.

Finally, do anything else as you did before with Lego.
