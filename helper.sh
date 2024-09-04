docker_exec_by_label() {
    if [ "$#" -ne 3 ]; then
        echo "Usage: docker_exec_by_label <label_key> <label_value> <command>"
        return 1
    fi

    local label_key=$1
    local label_value=$2
    local command=$3
    echo "Docker exec command by label"
    echo "Label:   ${label_key}=${label_value}"
    echo "Command: $command"

    local container_ids=$(docker ps -q --filter "label=${label_key}=${label_value}")

    if [ -z "$container_ids" ]; then
        echo "No running containers found with label ${label_key}=${label_value}."
        return 1
    fi

    for container_id in $container_ids; do
        echo "Executing command in container: $container_id"
        docker exec "$container_id" bash -c "$command"
    done
}

docker_copy_by_label() {
    if [ "$#" -ne 4 ]; then
        echo "Usage: docker_exec_by_label <label_key> <label_value> <source_path> <destination_path>"
        return 1
    fi

    local label_key=$1
    local label_value=$2
    local source_path=$3
    local destination_path=$4
    echo "Docker copy file by label"
    echo "Label:            ${label_key}=${label_value}"
    echo "Source path:      $source_path"
    echo "Destination path: $destination_path"

    local container_ids=$(docker ps -q --filter "label=${label_key}=${label_value}")

    if [ -z "$container_ids" ]; then
        echo "No running containers found with label ${label_key}=${label_value}."
        return 1
    fi

    for container_id in $container_ids; do
        echo "Copying $source_path to container ${container_id}:${destination_path}"
        docker cp "${source_path}" "${container_id}:${destination_path}"
    done
}

