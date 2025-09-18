#!/bin/sh

# 執行資料庫遷移
php artisan migrate --force

# 執行資料庫種子
php artisan db:seed --force

# 啟動 Laravel 伺服器
php artisan serve --host=0.0.0.0 --port=10000