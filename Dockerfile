# 使用官方的 PHP 8.2 CLI Alpine 映像檔作為基礎
FROM php:8.2-cli-alpine AS base

# 安裝系統依賴套件與 PHP 擴充套件
RUN apk add --no-cache git libzip-dev postgresql-dev && \
    docker-php-ext-install pdo pdo_pgsql zip

# 從官方 Composer 映像檔中複製 Composer 執行檔
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 複製我們自訂的 PHP 設定檔目錄
COPY .render/php /usr/local/etc/php/conf.d

# --- 建置階段 ---
FROM base AS builder

WORKDIR /app

# 僅複製 composer 相關檔案
COPY composer.json composer.lock ./

# 安裝依賴套件，並暫時禁用 php.ini
RUN php -n /usr/bin/composer install --no-dev --no-scripts --optimize-autoloader

# 複製應用程式的其他所有檔案
COPY . .

# --- 最終映像檔 ---
FROM base AS final

WORKDIR /app

# 從建置階段複製已安裝好的 vendor 目錄和所有程式碼
COPY --from=builder /app .

# 重新執行 autoloader scripts，同樣禁用 php.ini 且不執行任何腳本
RUN php -n /usr/bin/composer dump-autoload --optimize --no-scripts

# 告訴 Docker 容器要開放哪個連接埠
EXPOSE 10000

# 定義容器啟動時要執行的預設指令
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=10000"]