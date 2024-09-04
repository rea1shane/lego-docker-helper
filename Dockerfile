# https://github.com/go-acme/lego/blob/master/Dockerfile
FROM goacme/lego 

RUN apk add --no-cache docker-cli

COPY helper.sh /helper/

ENTRYPOINT [ "crond", "-f" ]
