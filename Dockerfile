FROM composer AS builder

WORKDIR /app

RUN \
  composer require psy/psysh \
  && composer audit

RUN wget 'psysh.org/manual/en/php_manual.sqlite'

FROM php:cli-alpine

WORKDIR /app

COPY --from=builder /app/vendor /app/vendor

RUN mkdir /usr/local/share/psysh

COPY --from=builder /app/php_manual.sqlite /usr/local/share/psysh/php_manual.sqlite

ENTRYPOINT [ "/app/vendor/bin/psysh" ]