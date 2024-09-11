#!/bin/bash
# Just for testing, don't need to care.

source /helper.sh

# docker_exec_by_label
docker_exec_by_label
docker_exec_by_label helper.docker.lego.discovery.domain=example.com "nginx -s reload"
docker_exec_by_label non-existent-label "nginx -s reload"
docker_exec_by_label helper.docker.lego.discovery.domain=example.com "Bad command"
docker_exec_by_label helper.docker.lego.discovery.domain=example.com
docker_exec_by_label "nginx -s reload"
docker_exec_by_label helper.docker.lego.discovery.domain=example.com nginx -s reload

# docker_copy_by_label
docker_copy_by_label
docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar /helper.sh /helper.sh
docker_copy_by_label non-existent-label /helper.sh /helper.sh
docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar /non-existent-file /helper.sh
docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar /helper.sh /non-existent-dir/helper.sh
docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar /helper.sh
docker_copy_by_label /helper.sh /helper.sh
docker_copy_by_label helper.docker.lego.discovery.domain=foo.bar /helper.sh /some where/helper.sh

# docker_restart_by_label
docker_restart_by_label
docker_restart_by_label helper.docker.lego.discovery.domain=foo.bar
docker_restart_by_label non-existent-label
docker_restart_by_label helper.docker.lego.discovery.domain=foo.bar something-other
