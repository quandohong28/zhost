#!/bin/bash

# Install script for Latest WordPress on local dev

# Hardcoded variables that shouldn't change much
MYSQL='/usr/bin/mysql'

# DB Variables from arguments
mysqlhost="localhost"
mysqldb=$1
mysqluser=$2
mysqlpass=$3

# WordPress Variables
wptitle="My Blog"
wpuser="admin"
wppass="Admin2024@"
wpemail="admin@gmail.com"

# Site Variables
siteurl=$4
website_dir="/home/$siteurl/public_html"

# In case of missing parameters, display usage information
if [ -z "$siteurl" ]; then
    echo "Bạn cần truyền vào đầy đủ các tham số: $0 mysqlhost mysqldb mysqluser mysqlpass siteurl"
    exit 1
fi

# Setup DB & DB User
$MYSQL -u root -e "CREATE DATABASE IF NOT EXISTS $mysqldb; GRANT ALL ON $mysqldb.* TO '$mysqluser'@'$mysqlhost' IDENTIFIED BY '$mysqlpass'; FLUSH PRIVILEGES"

# Use local WordPress files from /opt/wordpress
if [ -d /opt/wordpress ]; then
    echo "Đang sử dụng nguồn wordpress từ /opt/wordpress"
    if [ "$(ls -A $website_dir)" ]; then
        echo "Cảnh báo: Thư mục $website_dir không trống. Đang xoá các file cũ"
            rm -rf $website_dir/*
    fi
    cp -r /opt/wordpress/* $website_dir
else
    echo "Lỗi: /opt/wordpress không tồn tại"
    exit 1
fi

# Build wp-config.php file
if [ -f "$website_dir/wp-config.php" ]; then
# Sử dụng sed để thay đổi các giá trị trong wp-config.php
    sed -i -e "s/define( 'DB_NAME', '.*' );/define( 'DB_NAME', '${mysqldb}' );/" \
           -e "s/define( 'DB_USER', '.*' );/define( 'DB_USER', '${mysqluser}' );/" \
           -e "s/define( 'DB_PASSWORD', '.*' );/define( 'DB_PASSWORD', '${mysqlpass}' );/" \
           "$website_dir/wp-config.php"

    echo "Đã cập nhật $website_dir/public_html/wp-config.php thành công!"

else
echo "File wp-config.php không tồn tại"
fi

#import database từ db sẵn
$MYSQL -u root -e "mysql -u $mysqluser -p $mysqluser < /home/bytealitech.com/sample.sql"

# Sửa thông tin wp_option
$MYSQL -u root -e "USE $mysqldb; UPDATE wp_options SET option_value = 'https://$siteurl' WHERE option_name IN ('siteurl', 'home');"


echo "Cài đặt wordpress thành công!!!"
