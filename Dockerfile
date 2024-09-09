# https://github.com/go-acme/lego/blob/master/buildx.Dockerfile
ARG LEGO_TAG=latest
FROM goacme/lego:${LEGO_TAG}

RUN apk add --no-cache docker-cli

COPY helper.sh /

ENTRYPOINT [ "crond" ]
CMD [ "-f" ]
