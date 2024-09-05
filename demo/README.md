# Lego Docker helper demo

First run this Docker Compose:

```shell
docker compose up -d
```

Then enter the `demo-lego-docker-helper` container:

```shell
docker exec -it demo-lego-docker-helper /bin/sh
```

Need source script first to use helper functions:

```shell
source /helper.sh
```

Example of execute command in containers with label:

```shell
docker_exec_by_label helper.docker.lego.discovery.domain=example.com "nginx -s reload"
```

Example of copy file to containers with label:

```shell
docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar /helper.sh /helper.sh
```

Example of restart containers with label:

```shell
docker_restart_by_label helper.docker.lego.discovery.domain=foo.bar
```
