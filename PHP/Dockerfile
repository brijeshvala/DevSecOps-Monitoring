FROM composer:2 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --ignore-platform-reqs

FROM php:8.2-fpm-alpine
WORKDIR /var/www/html
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --chown=appuser:appgroup --from=vendor /app/vendor /var/www/html/vendor
COPY --chown=appuser:appgroup . .
USER appuser
CMD ["php-fpm"]