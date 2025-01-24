docker_copy() {
    local source_path="$1"
    local container="$2"
    local destination_path="$3"

    log_doing "Copying $source_path to $container:$destination_path"
    output=$(docker cp "$source_path" "$container:$destination_path" 2>&1)
    deal_result $? "$output"
}

#########
# Utils #
#########

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
