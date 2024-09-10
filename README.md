# [Lego](https://github.com/go-acme/lego) Docker helper

Use Docker label to determine which certs should be deployed to which containers and deploy them via the Docker client.

No changes were made other than installing `docker-cli` and [`helper.sh`](https://github.com/rea1shane/lego-docker-helper/blob/main/helper.sh) on the original image. See [Dockerfile](https://github.com/rea1shane/lego-docker-helper/blob/main/Dockerfile).

Features:

- Use `crond` as daemon.
- Provide some useful functions ([demo](https://github.com/rea1shane/lego-docker-helper/tree/main/demo)):
  - Copy certs to containers with specified Docker label.
  - Execute command in containers with specified Docker label.
  - Restart containers with specified Docker label.

## Usage

First, adding labels to containers where certs need to be deployed, like [this](https://github.com/rea1shane/lego-docker-helper/blob/main/demo/docker-compose.yaml#L11). Then down and up containers to make labels take effect.

Second, make your own hook script, like [this](https://github.com/rea1shane/lego-docker-helper/blob/main/hook.sh.example).

Then, up lego-docker-helper container and mount `docker.sock` in it with `rw` permission, like [this](https://github.com/rea1shane/lego-docker-helper/blob/main/demo/docker-compose.yaml#L6). Also don't forget to mount your hook script into the container.

> [!IMPORTANT]
>
> By default, container use UTC. To set cron expressions by local time, specify your time zone with the environment variable `TZ` when start the container. See [list with all the timezones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List).

Finally, do anything else as you did before with Lego.

> [!TIP]
>
> Edit cron jobs via `crontab -e` to ensure that `crond` can be reloaded.
