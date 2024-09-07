# [Lego](https://github.com/go-acme/lego) Docker helper

Use Docker label to determine which certs should be deployed to which containers and deploy them via the Docker client.

No changes were made other than installing `docker-cli` and [`helper.sh`](https://github.com/rea1shane/lego-docker-helper/blob/main/helper.sh) on the original image. See [Dockerfile](https://github.com/rea1shane/lego-docker-helper/blob/main/Dockerfile).

Features:

- Use `crond` as daemon.
- Provide some useful functions ([demo](https://github.com/rea1shane/lego-docker-helper/tree/main/demo)):
  - Copy certs to containers with specified Docker label.
  - Execute command in containers with specified Docker label.
  - Restart containers with specified Docker label.

> [!TIP]
>
> Edit cron jobs via `crontab -e` to ensure that `crond` can be reloaded.

## Usage

First, adding labels to containers where certs need to be deployed, like [this](https://github.com/rea1shane/lego-docker-helper/blob/main/demo/docker-compose.yaml#L11). Down and up them to make labels effect.

Second, write your own hook script, like this:

```shell
#!/bin/bash
# reference: https://go-acme.github.io/lego/usage/cli/obtain-a-certificate/index.html

source /helper.sh

if [ "$LEGO_CERT_DOMAIN" = "example.com" ]; then
    nginx_cert_dir="/etc/nginx/certificates"
    docker_copy_by_label helper.docker.lego.discovery.domain=example.com "$LEGO_CERT_PATH" "$nginx_cert_dir/example.com.crt"
    docker_copy_by_label helper.docker.lego.discovery.domain=example.com "$LEGO_CERT_KEY_PATH" "$nginx_cert_dir/example.com.key"
    docker_exec_by_label helper.docker.lego.discovery.domain=example.com "nginx -s reload"

elif [ "$LEGO_CERT_DOMAIN" = "foo.bar" ]; then
    default_cert_dir="/certificates"
    docker_exec_by_label "helper.docker.lego.discovery.id=$domain:traefik" "mkdir -p $default_cert_dir"
    docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar "$LEGO_CERT_PATH" "$default_cert_dir/foo.bar.crt"
    docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar "$LEGO_CERT_KEY_PATH" "$default_cert_dir/foo.bar.key"
    docker_restart_by_label helper.docker.lego.discovery.domain=foo.bar

fi
```

Or set different behaviors for different components:

```shell
#!/bin/bash

source /helper.sh

domain="example.com"
cert_dir="/certificates"

if [ "$LEGO_CERT_DOMAIN" = "$domain" ]; then
    # adguardhome
    docker_exec_by_label "helper.docker.lego.discovery.id=$domain:adguardhome" "mkdir -p $cert_dir"
    docker_copy_by_label "helper.docker.lego.discovery.id=$domain:adguardhome" "$LEGO_CERT_PATH" "$cert_dir/chain.crt"
    docker_copy_by_label "helper.docker.lego.discovery.id=$domain:adguardhome" "$LEGO_CERT_KEY_PATH" "$cert_dir/private.key"
    docker_exec_by_label "helper.docker.lego.discovery.id=$domain:adguardhome" "/opt/adguardhome/AdGuardHome -s reload"

    # traefik
    docker_exec_by_label "helper.docker.lego.discovery.id=$domain:traefik" "mkdir -p $cert_dir"
    docker_copy_by_label "helper.docker.lego.discovery.id=$domain:traefik" "$LEGO_CERT_PATH" "$cert_dir/chain.crt"
    docker_copy_by_label "helper.docker.lego.discovery.id=$domain:traefik" "$LEGO_CERT_KEY_PATH" "$cert_dir/private.key"
    docker_restart_by_label "helper.docker.lego.discovery.id=$domain:traefik"
fi
```

Then, up lego-docker-helper container and mount `docker.sock` in it with `rw` permission, like [this](https://github.com/rea1shane/lego-docker-helper/blob/main/demo/docker-compose.yaml#L6). Also don't forget to mount your hook script into the container.

Finally, do anything else as you did before with Lego.

> [!IMPORTANT]
>
> The time zone inside the container is UTC, modify your cron expression according to your time zone.
