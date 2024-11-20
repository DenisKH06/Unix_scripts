#!/bin/bash

mini=1
num_files=0
flag=0
directories=(".")

help(){
    echo "Usage: $0 [--help] [-h] [-N] [-s minsize] [--] [dir...]"
    echo ""
    echo "Опции:"
    echo "  --help      Вывод справки о формате и выход."
    echo "  -N          Количество файлов, если не задано - все файлы (N - число, например -10)."
    echo "  -s minsize  Минимальный размер файла, по умолчанию 1 байт."
    echo "  -h          Вывод размера в "человекочитаемом формате"."
    echo "  dir...      Каталог(и) поиска, если не заданы - текущий каталог (.)"
    echo "  --          Разделение опций и каталога."
    exit 0
}


while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --help)
            help
            ;;
        -h)
            flag=1
            shift
            ;;
        -s)
            shift
            if [[ "$1" =~ ^[0-9]+$ ]]; then
                mini=$1
            else
                echo "Ошибка: Недопустимое значение для -s. Должно быть положительным целым числом." >&2
                exit 1
            fi
            shift
            ;;
        -[0-9]*)
            num_files=${1#-} # извлекаем количество файлов
            shift
            ;;
        --)
            shift
            directories=("$@")
            break
            ;;
        -*)
            echo "Ошибка: Неизвестная опция '$1'" >&2
            exit 1
            ;;
        *)
            directories+=("$1")
            shift
            ;;
    esac
done



if [[ "$mini" -lt 1 ]]; then
    echo "Ошибка: Минимальный размер (-s) должен быть не менее 1 байта." >&2
    exit 1
fi

# создаем команду для поиска файлов
    find="find ${directories[*]} -type f -size +${mini}c -printf '%s %p\n' 2>/dev/null"

    # человеческий формат
    if [[ "$flag" -eq 1 ]]; then
        find+=" | sort -rh" # -r сортировать в обратном порядке -h использовать чел.формат
    else
        find+=" | sort -rn" # -r сортировать в обратном порядке -n сортировка числовых значений
    fi

    # ограничивание количества фйлов 
    if [[ "$num_files" -gt 0 ]]; then
        find+=" | head -n $num_files"
    fi

    # Выполняем команду
    eval "$find" | while read -r size path; do
        if [[ "$flag" -eq 1 ]]; then
            size=$(numfmt --to=si --suffix=B "$size") #преобразуем числа в человеческий формат
        fi
        echo "$size $path"
    done