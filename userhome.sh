#!/bin/bash

current_user=$(whoami)
file_name="/etc/passwd"


while (( "$#" )); do
    if [[ "$1" == "-f" ]]; then
        shift
        file_name=$1
    else
        current_user=$1
    fi
    shift
done


if [[ ! -e "$file_name" ]]; then
    echo "Ошибка: Файл '$file_name' не найден" >&2
    exit 2
fi


home_string=$(grep -E "^$current_user:" "$file_name" 2>/dev/null)

if [[ -z "$home_string" ]]; then
    echo "Ошибка: Пользователь '$current_user' не найден" >&2
    exit 1
fi


result=${home_string#*:*:*:*:*:}  
result=${result%:*}
echo "$result"

exit 0


