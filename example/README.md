Load script first:

```shell
source /helper.sh
```

Example `docker_exec_by_label`:

```shell
docker_exec_by_label helper.docker.lego.discovery.domain=example.com "nginx -s reload"
```

Example `docker_copy_by_label`:

```shell
docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar /helper.sh /helper.sh
```

Example `docker_restart_by_label`:

```shell
docker_restart_by_label helper.docker.lego.discovery.domain=foo.bar
```
