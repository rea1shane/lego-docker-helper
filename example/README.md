NEED load script first:

```shell
source /helper.sh
```

Example of execute command in containers with a special label:

```shell
docker_exec_by_label helper.docker.lego.discovery.domain=example.com "nginx -s reload"
```

Example of copy file to containers with a special label:

```shell
docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar /helper.sh /helper.sh
```

Example of restart containers with a special label:

```shell
docker_restart_by_label helper.docker.lego.discovery.domain=foo.bar
```
