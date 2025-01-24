#!/bin/bash

source /actions.sh

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

echo "Successed $successed_count/$matched_count"
