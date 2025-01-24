#!/bin/bash

echo "Filtering containers labeled with label=helper.docker.lego.domain=$LEGO_CERT_DOMAIN"

containers=$(docker ps --filter "label=helper.docker.lego.enable=true" --filter "label=helper.docker.lego.domain=$LEGO_CERT_DOMAIN" --format "{{.ID}}")

matched_count=0
successed_count=0

for container in $containers; do
    email=$(docker inspect -f '{{index .Config.Labels "helper.docker.lego.email"}}' "$container")
    if [[ -n "$email" ]] && [[ "$email" != "$LEGO_ACCOUNT_EMAIL" ]]; then
        continue
    fi

    ((matched_containers++))

    echo "======"

    #TODO FINISH IT

    echo "======"
done

echo "Successed: $successed_count/$matched_count"

# ----------------------------------------------------------------------------

# Actions
docker_copy() {
    local source_path="$1"
    local container="$2"
    local destination_path="$3"

    log_info "Copying file $source_path to $container:$destination_path"
    output=$(docker cp "$source_path" "$container:$destination_path" 2>&1)
    deal_result $? "$output"
}

docker_exec_by_label() {
    local container="$1"
    local command="$2"

    log_info "Executing command in container $container. Command: $command"
    output=$(docker exec "$container" sh -c "$command" 2>&1)
    deal_result $? "$output"
}

docker_restart() {
    local container="$1"

    log_info "Restarting container $container"
    output=$(docker restart "$container" 2>&1)
    deal_result $? "$output"
}

# Utils
deal_result() {
    local code="$1"
    local output="$2"

    if [ $code -eq 0 ]; then
        log_success "OK"
    else
        log_error "ERROR:"
        echo "$output" | sed 's/^/    /'
    fi
}

log_error() {
    local arrow="\033[31m==>\033[0m"
    echo -e "$arrow $@"
}

log_info() {
    local arrow="\033[36m==>\033[0m"
    echo -e "$arrow $@"
}

log_success() {
    local arrow="\033[32m==>\033[0m"
    echo -e "$arrow $@"
}
