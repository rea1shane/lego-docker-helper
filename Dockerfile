ARG LEGO_TAG=latest
FROM goacme/lego:${LEGO_TAG}

RUN apk add --no-cache docker-cli

COPY helper.sh /

ENTRYPOINT [ "crond", "-f" ]
