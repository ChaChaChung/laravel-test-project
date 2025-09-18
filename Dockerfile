# 最終簡化版 Dockerfile
FROM php:8.2-cli-alpine

# 安裝 Laravel 需要的系統依賴和 PHP 擴充套件
RUN apk add --no-cache git libzip-dev postgresql-dev && \
    docker-php-ext-install pdo pdo_pgsql zip

# 安裝 Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

# 複製 composer 檔案並安裝依賴
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-interaction --no-plugins --no-scripts --prefer-dist --optimize-autoloader

# 複製應用程式的其餘所有檔案
COPY . .

# 產生優化過的 autoloader
RUN composer dump-autoload --optimize --no-scripts

# 開放連接埠
EXPOSE 10000

# 預設啟動指令
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=10000"]