ARG PHP_VERSION=8.4

FROM php:${PHP_VERSION}-cli-alpine AS builder

WORKDIR /app

COPY . /app/

RUN \
  chmod +x ./install-phive.sh \
  && ./install-phive.sh

RUN \
  chmod +x ./install-tools.sh \
  && ./install-tools.sh

RUN \
  composer install --no-dev --prefer-dist \
  && composer audit \
  && box compile

FROM php:${PHP_VERSION}-cli-alpine

COPY --from=builder /app/psysh /usr/local/bin/psysh

RUN psysh --update-manual

ENTRYPOINT [ "psysh" ]