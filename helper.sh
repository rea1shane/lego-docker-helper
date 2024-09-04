red_arrow="\033[31m==>\033[0m"
yellow_arrow="\033[33m==>\033[0m"
green_arrow="\033[32m==>\033[0m"
blue_arrow="\033[36m==>\033[0m"
purple_arrow="\033[35m==>\033[0m"

docker_exec_by_label() {
    if [ "$#" -ne 2 ]; then
        echo -e "$red_arrow Usage: docker_exec_by_label <label> <command>"
        return 1
    fi

    local label=$1
    local command=$2
    echo -e "$blue_arrow Docker exec command by label"
    echo -e "$blue_arrow Label: $label"
    echo -e "$blue_arrow Command: $command"

    local container_names=$(docker ps --filter "label=$label" --format "{{.Names}}")

    if [ -z "$container_names" ]; then
        echo -e "$yellow_arrow No running containers found with label $label"
        return 1
    fi

    for container_name in $container_names; do
        echo -e "$purple_arrow Executing command in container: $container_name"
        docker exec "$container_name" sh -c "$command"
    done

    echo -e "$green_arrow Done"
}

docker_copy_by_label() {
    if [ "$#" -ne 3 ]; then
        echo -e "$red_arrow Usage: docker_copy_by_label <label> <source_path> <destination_path>"
        return 1
    fi

    local label=$1
    local source_path=$2
    local destination_path=$3
    echo -e "$blue_arrow Docker copy file by label"
    echo -e "$blue_arrow Label: $label"
    echo -e "$blue_arrow Source path: $source_path"
    echo -e "$blue_arrow Destination path: $destination_path"

    local container_names=$(docker ps --filter "label=$label" --format "{{.Names}}")

    if [ -z "$container_names" ]; then
        echo -e "$yellow_arrow No running containers found with label $label"
        return 1
    fi

    for container_name in $container_names; do
        echo -e "$purple_arrow Copying $source_path to container $container_name:$destination_path"
        docker cp "$source_path" "$container_name:$destination_path"
    done

    echo -e "$green_arrow Done"
}

docker_restart_by_label() {
    if [ "$#" -ne 1 ]; then
        echo -e "$red_arrow Usage: docker_restart_by_label <label>"
        return 1
    fi

    local label=$1
    echo -e "$blue_arrow Docker restart by label"
    echo -e "$blue_arrow Label: $label"

    local container_names=$(docker ps --filter "label=$label" --format "{{.Names}}")

    if [ -z "$container_names" ]; then
        echo -e "$yellow_arrow No running containers found with label $label"
        return 1
    fi

    for container_name in $container_names; do
        echo -e "$purple_arrow Restarting container: $container_name"
        docker restart "$container_name"
    done

    echo -e "$green_arrow Done"
}
