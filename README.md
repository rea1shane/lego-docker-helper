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
> Edit cron jobs via `crontab -e`.

## Usage

First, Mount `docker.sock` with `rw` permission to lego-docker-helper container, like [this](https://github.com/rea1shane/lego-docker-helper/blob/main/demo/docker-compose.yaml#L6).

Second, Add labels to target containers, like [this](https://github.com/rea1shane/lego-docker-helper/blob/main/demo/docker-compose.yaml#L11).

Then, write your own hook script, like this:

```shell
#!/bin/bash
# reference: https://go-acme.github.io/lego/usage/cli/obtain-a-certificate/index.html

source /helper.sh

if [ "$LEGO_CERT_DOMAIN" = "example.com" ]; then
    nginx_cert_dir="/etc/nginx/certificates"
    docker_copy_by_label helper.docker.lego.discovery.domain=example.com "$LEGO_CERT_PATH" "$nginx_cert_dir"
    docker_copy_by_label helper.docker.lego.discovery.domain=example.com "$LEGO_CERT_KEY_PATH" "$nginx_cert_dir"
    docker_exec_by_label helper.docker.lego.discovery.domain=example.com "nginx -s reload"

elif [ "$LEGO_CERT_DOMAIN" = "foo.bar" ]; then
    default_cert_dir="/certificates"
    docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar "$LEGO_CERT_PATH" "$default_cert_dir"
    docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar "$LEGO_CERT_KEY_PATH" "$default_cert_dir"
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
    docker_copy_by_label "helper.docker.lego.discovery.id=$domain:adguardhome" "$LEGO_CERT_PATH" "$cert_dir"
    docker_copy_by_label "helper.docker.lego.discovery.id=$domain:adguardhome" "$LEGO_CERT_KEY_PATH" "$cert_dir"
    docker_exec_by_label "helper.docker.lego.discovery.id=$domain:adguardhome" "/opt/adguardhome/AdGuardHome -s reload"

    # traefik
    docker_copy_by_label "helper.docker.lego.discovery.id=$domain:traefik" "$LEGO_CERT_PATH" "$cert_dir"
    docker_copy_by_label "helper.docker.lego.discovery.id=$domain:traefik" "$LEGO_CERT_KEY_PATH" "$cert_dir"
    docker_restart_by_label "helper.docker.lego.discovery.id=$domain:traefik"
fi
```

Finally, do anything else as you did before with Lego.
