# 使用官方的 PHP 8.2 CLI Alpine 映像檔作為基礎
FROM php:8.2-cli-alpine

# 安裝系統依賴套件與 PHP 擴充套件
# git 是 composer 需要的
# libzip-dev 是 zip 擴充套件需要的
# pdo_pgsql 是 Laravel 連接 PostgreSQL 需要的
RUN apk add --no-cache git libzip-dev && \
    docker-php-ext-install pdo pdo_pgsql zip

# 從官方 Composer 映像檔中複製 Composer 執行檔
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 設定工作目錄
WORKDIR /app

# 將專案所有檔案複製到工作目錄中
COPY . .

# Render 會透過 render.yaml 的 startCommand 來啟動服務，所以這裡不需要 CMD