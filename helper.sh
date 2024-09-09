docker_exec_by_label() {
    if [ "$#" -ne 2 ]; then
        log_error "Usage: docker_exec_by_label <label> <command>"
        return 1
    fi

    local label=$1
    local command=$2
    echo "========"
    echo "Action: exec"
    echo "Label:  $label"
    echo "Cmd:    $command"
    echo "========"

    local container_names=$(docker ps --filter "label=$label" --format "{{.Names}}")

    if [ -z "$container_names" ]; then
        no_running_containers
        return 1
    fi

    for container_name in $container_names; do
        log_doing "Executing command in container: $container_name"
        output=$(docker exec "$container_name" sh -c "$command" 2>&1)
        deal_result $? "$output"
    done

    completed
}

docker_copy_by_label() {
    if [ "$#" -ne 3 ]; then
        log_error "Usage: docker_copy_by_label <label> <source_path> <destination_path>"
        return 1
    fi

    local label=$1
    local source_path=$2
    local destination_path=$3
    echo "========"
    echo "Action: copy"
    echo "Label:  $label"
    echo "Src:    $source_path"
    echo "Dest:   $destination_path"
    echo "========"

    local container_names=$(docker ps --filter "label=$label" --format "{{.Names}}")

    if [ -z "$container_names" ]; then
        no_running_containers
        return 1
    fi

    for container_name in $container_names; do
        log_doing "Copying $source_path to container $container_name:$destination_path"
        output=$(docker cp "$source_path" "$container_name:$destination_path" 2>&1)
        deal_result $? "$output"
    done

    completed
}

docker_restart_by_label() {
    if [ "$#" -ne 1 ]; then
        log_error "Usage: docker_restart_by_label <label>"
        return 1
    fi

    local label=$1
    echo "========"
    echo "Action: restart"
    echo "Label:  $label"
    echo "========"

    local container_names=$(docker ps --filter "label=$label" --format "{{.Names}}")

    if [ -z "$container_names" ]; then
        no_running_containers
        return 1
    fi

    for container_name in $container_names; do
        log_doing "Restarting container: $container_name"
        output=$(docker restart "$container_name" 2>&1)
        deal_result $? "$output"
    done

    completed
}

#########
# Utils #
#########

no_running_containers() {
    log_warning "No running containers found with label $label"
}

deal_result() {
    local code=$1
    local output=$2
    if [ $code -eq 0 ]; then
        log_success "OK"
    else
        log_error "ERROR:"
        echo "$output" | sed 's/^/    /'
    fi
}

completed() {
    log_finish "All tasks have been completed"
}

log_error() {
    local arrow="\033[31m==>\033[0m"
    echo -e "$arrow $@"
}

log_warning() {
    local arrow="\033[33m==>\033[0m"
    echo -e "$arrow $@"
}

log_doing() {
    local arrow="\033[36m==>\033[0m"
    echo -e "$arrow $@"
}

log_success() {
    local arrow="\033[32m==>\033[0m"
    echo -e "$arrow $@"
}

log_finish() {
    local arrow="\033[35m==>\033[0m"
    echo -e "$arrow $@"
}
