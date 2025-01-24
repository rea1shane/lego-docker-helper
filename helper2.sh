#!/bin/bash

source /actions.sh

containers=$(docker ps --filter "label=helper.docker.lego.enable=true" --filter "label=helper.docker.lego.domain=$LEGO_CERT_DOMAIN" --format "{{.ID}}")

matched_count=0
successed_count=0
