# 使用官方的 PHP 8.2 CLI Alpine 映像檔作為基礎
FROM php:8.2-cli-alpine

# 安裝系統依賴套件與 PHP 擴充套件
RUN apk add --no-cache git libzip-dev postgresql-dev && \
    docker-php-ext-install pdo pdo_pgsql zip

# 從官方 Composer 映像檔中複製 Composer 執行檔
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 設定 PHP 設定檔路徑的環境變數
ENV PHP_INI_SCAN_DIR /usr/local/etc/php/conf.d

# 複製我們自訂的 PHP 設定檔目錄
COPY .render/php /usr/local/etc/php/conf.d

# 設定工作目錄
WORKDIR /app

# 僅複製 composer 相關檔案
COPY composer.json composer.lock ./

# 安裝依賴套件
RUN composer install --no-dev --no-scripts --optimize-autoloader

# 複製應用程式的其他所有檔案
COPY . .

# 重新執行 autoloader scripts
RUN composer dump-autoload --optimize

# 告訴 Docker 容器要開放哪個連接埠
EXPOSE 10000

# 定義容器啟動時要執行的預設指令
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=10000"]