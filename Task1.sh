#!/bin/bash


option_S=0
option_s=0
exit_code=0
total_size=0


usage() {
    echo "Usage: $0 [options] -- file1 file2 ..."
    echo "Опции:"
    echo "  -s          Выводит в конце сумарный размер файла."
    echo "  -S          Выводит только сумарный размер файла ."
    echo "  --usage     Показывает краткую инструкцию."
    echo "  --help      Показывает детальную инструкцию."
    exit 0
}

help() {
    echo "Usage: $0 [options] -- file1 file2 ..."
    echo
    echo "Опции:"
    echo "  -s          Выводит в конце сумарный размер файла."
    echo "  -S          Выводит только сумарный размер файла."
    echo "  --usage     Показывает инструкцию по использованию."
    echo "  --help      Показывает детальнцю помощь."
    echo
    echo "Этот скрипт вычисляет и отображает размер указанных файлов."
    echo "Если используется опция -s, отображается общий размер всех файлов в конце вывода."
    echo "Если используется опция -S, отображается только общий размер."
    echo
    echo "Специальные возможности этого сценария:"
    echo "Поддерживает файлы с пробелами и специальными символами."
    echo "Файлам, начинающимся с '-', должен предшествовать '--'."
    echo
    echo "Exit codes:"
    echo "  0 - Нет ошибок."
    echo "  1 - Один или несколько файлов не существует"
    echo "  2 - Введен неподдерживаемый файл."
    exit 0
}


while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -s)
            option_s=1
            ;;
        -S)
            option_S=1
            ;;
        --usage)
            usage
            ;;
        --help)
            help
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "Ошибка неизвестная опция '$1'" >&2
            exit 2
            ;;
        *)
            break
            ;;
    esac
    shift
done


if [[ "$#" -eq 0 ]]; then
    echo "Ошибка: файлов нет" >&2
    exit 2
fi

# Обработка файлов
while [[ "$#" -gt 0 ]]; do
    file="$1"
    shift
    if [[ !(-e "$file") ]]; then
        echo "Ошибка: Файл '$file' не найден." >&2
        exit_code=1
        continue
    fi

    size=$(stat --format="%s" -- "$file")
    if [[ -z "$size" ]]; then
        echo "Ошибка: Не получилось получить размер файла '$file'." >&2
        exit_code=1
        continue
    fi

    total_size=$((total_size + size))

    if [[ "$option_S" -eq 0 ]]; then
        echo "$size $file"
    fi
done


if [[ $option_S -eq 1 || $option_s -eq 1 ]]; then
    echo "Суммарный размер всех файлов: $total_size байтов"
fi

exit $exit_code