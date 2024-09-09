> [!NOTE]
>
> Some commands for testing that the user doesn't need to care about.

### `docker_exec_by_label`

```shell
docker_exec_by_label helper.docker.lego.discovery.domain=example.com1 "nginx -s reload"
```

```shell
docker_exec_by_label helper.docker.lego.discovery.domain=example.com "nginx -s reload1"
```

```shell
docker_exec_by_label helper.docker.lego.discovery.domain=example.com
```

```shell
docker_exec_by_label "nginx -s reload"
```

```shell
docker_exec_by_label helper.docker.lego.discovery.domain=example.com nginx -s reload
```

### `docker_copy_by_label`

```shell
docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar1 /helper.sh /helper.sh
```

```shell
docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar /helper1.sh /helper.sh
```

```shell
docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar /helper.sh /1/helper.sh
```

```shell
docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar /helper.sh
```

```shell
docker_copy_by_label /helper.sh /helper.sh
```

```shell
docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar /helper.sh /some where/helper.sh
```

### `docker_restart_by_label`

```shell
docker_restart_by_label helper.docker.lego.discovery.domain=foo.bar1
```

```shell
docker_restart_by_label
```

```shell
docker_restart_by_label helper.docker.lego.discovery.domain=foo.bar something
```
