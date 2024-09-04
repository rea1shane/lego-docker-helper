docker_exec_by_label() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: docker_exec_by_label <label> <command>"
        return 1
    fi

    local label=$1
    local command=$2
    echo "Docker exec command by label"
    echo "Label:   $label"
    echo "Command: $command"

    local container_names=$(docker ps --filter "label=$label" --format "{{.Names}}")

    if [ -z "$container_names" ]; then
        echo "No running containers found with label $label"
        return 1
    fi

    for container_name in $container_names; do
        echo "Executing command in container: $container_name"
        docker exec "$container_name" bash -c "$command"
    done
}

docker_copy_by_label() {
    if [ "$#" -ne 3 ]; then
        echo "Usage: docker_copy_by_label <label> <source_path> <destination_path>"
        return 1
    fi

    local label=$1
    local source_path=$2
    local destination_path=$3
    echo "Docker copy file by label"
    echo "Label:            $label"
    echo "Source path:      $source_path"
    echo "Destination path: $destination_path"

    local container_names=$(docker ps --filter "label=$label" --format "{{.Names}}")

    if [ -z "$container_names" ]; then
        echo "No running containers found with label $label"
        return 1
    fi

    for container_name in $container_names; do
        echo "Copying $source_path to container $container_name:$destination_path"
        docker cp "$source_path" "$container_name:$destination_path"
    done
}

docker_restart_by_label() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: docker_restart_by_label <label>"
        return 1
    fi

    local label=$1
    echo "Docker restart by label"
    echo "Label: $label"

    local container_names=$(docker ps --filter "label=$label" --format "{{.Names}}")

    if [ -z "$container_names" ]; then
        echo "No running containers found with label $label"
        return 1
    fi

    for container_name in $container_names; do
        echo "Restarting container: $container_name"
        docker restart "$container_name"
    done
}
