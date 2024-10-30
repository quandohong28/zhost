#!/bin/bash

# Kiểm tra số lượng tham số
if [ "$#" -ne 4 ]; then
    echo "Sử dụng: $0 <file_path> <new_db_name> <new_db_user> <new_db_password>"
    exit 1
fi

# Lưu trữ các tham số
file_path=$1
new_db_name=$2
new_db_user=$3
new_db_password=$4

# Sử dụng sed để thay đổi các giá trị trong wp-config.php
# Kiểm tra xem file wp-config.php có tồn tại không
if [ -f "$file_path" ]; then
    # Sử dụng sed để thay đổi các giá trị trong wp-config.php
    sed -i -e "s/define( 'DB_NAME', '.*' );/define( 'DB_NAME', '${new_db_name}' );/" \
           -e "s/define( 'DB_USER', '.*' );/define( 'DB_USER', '${new_db_user}' );/" \
           -e "s/define( 'DB_PASSWORD', '.*' );/define( 'DB_PASSWORD', '${new_db_password}' );/" \
           "$file_path"

    echo "Đã cập nhật wp-config.php thành công!"
else
    echo "Lỗi: $file_path không tồn tại!"
fi
