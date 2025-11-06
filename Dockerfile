ARG PHP_VERSION

FROM php:${PHP_VERSION}-cli-alpine AS installer

WORKDIR /app

RUN \
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }" \
  && php composer-setup.php \
  && php -r "unlink('composer-setup.php');"

COPY . /app/

RUN \
  php composer.phar install --no-dev --prefer-dist \
  && php composer.phar audit

FROM boxproject/box AS builder

WORKDIR /app

COPY --from=installer /app/ /app/

RUN /box.phar compile

FROM php:${PHP_VERSION}-cli-alpine

COPY --from=builder /app/psysh /usr/local/bin/psysh

RUN psysh --update-manual

ENTRYPOINT [ "psysh" ]