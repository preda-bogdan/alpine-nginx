FROM alpine:3.7

VOLUME ["/DATA"]

# hadolint ignore=DL3018
RUN echo 'http://dl-4.alpinelinux.org/alpine/latest-stable/main/' >> /etc/apk/repositories\
    && apk update \
    && apk add --no-cache \
    bash \
    less \
    nano \
    sudo \
    shadow \
    nginx \
    ca-certificates \
    openssh-client \
    git \
    curl \
    rsync \
    musl \
    && apk --update --no-cache add tar
RUN rm -rf /var/cache/apk/*


ENV PATH /DATA/bin:$PATH

RUN sed -i "s/nginx:x:100:101:nginx:\\/var\\/lib\\/nginx:\\/sbin\\/nologin/nginx:x:100:101:nginx:\\/DATA:\\/bin\\/bash/g" /etc/passwd && \
    sed -i "s/nginx:x:100:101:nginx:\\/var\\/lib\\/nginx:\\/sbin\\/nologin/nginx:x:100:101:nginx:\\/DATA:\\/bin\\/bash/g" /etc/passwd-


COPY files/nginx.conf /etc/nginx/
COPY files/run.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /var/www/html

EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]
