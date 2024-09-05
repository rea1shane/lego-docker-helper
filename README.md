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

First, Mount `docker.sock` with `rw` permission to lego-docker-helper container, like [this](https://github.com/rea1shane/lego-docker-helper/blob/main/demo/docker-compose.yaml#L6).

Second, Add labels to target containers, like [this](https://github.com/rea1shane/lego-docker-helper/blob/main/demo/docker-compose.yaml#L11).

Then, write your own hook script, like this:

```shell
#!/bin/bash
# reference: https://go-acme.github.io/lego/usage/cli/obtain-a-certificate/index.html

source /helper.sh

if [ "$LEGO_CERT_DOMAIN" = "example.com" ]; then
  docker_copy_by_label helper.docker.lego.discovery.domain=example.com "$LEGO_CERT_PATH" /etc/postfix/certificates
  docker_copy_by_label helper.docker.lego.discovery.domain=example.com "$LEGO_CERT_KEY_PATH" /etc/postfix/certificates
  docker_exec_by_label helper.docker.lego.discovery.domain=example.com "nginx -s reload"
fi

if [ "$LEGO_CERT_DOMAIN" = "foo.bar" ]; then
  docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar "$LEGO_CERT_PATH" /certificates
  docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar "$LEGO_CERT_KEY_PATH" /certificates
  docker_restart_by_label helper.docker.lego.discovery.domain=foo.bar
fi
```

Finally, do anything else as you did before with Lego.
