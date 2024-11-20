#!/bin/bash

option_a=0
option_v=0
flag=0

parameters=""

show_help() {
    echo "$0 [-a] [-v] [--] [parameters...]"
    echo "  -a             Включить опцию a"
    echo "  -v             Включить опцию v"
    echo "  --help         Показать справку"
    echo "  --version      Показать информацию о версии"
    exit 0
}

show_version() {
    echo "$0 version 1.0"
    echo "Автор: Денис" 
    exit  0
}


for arg in "$@"; do
    if [[ $flag -eq 1 ]]; then
        parameters+="$arg "

    elif [[ $arg == "--" ]]; then
        flag=1

    elif [[ $arg == "--help" ]]; then
        show_help

    elif [[ $arg == "--version" ]]; then
        show_version

    elif [[ $arg == "-a" ]]; then
        option_a=1
    
    elif [[ $arg == "-v" ]]; then
        option_v=1
    
    elif [[ $arg == -* ]]; then
        echo "Ошибка: неизвестная опция '$arg'" >&2
        exit 1
    else
        parameters+="$arg "
    fi
done

if [[ $option_a -eq 1 ]];then
    echo "-a задана"
else 
    echo "-a не задана"
fi

if [[ $option_v -eq 1 ]];then
    echo "-v задана"
else 
    echo "-v не задана"
fi


if [[ -n $parameters ]];then
    for arg in $parameters; do
        echo "$arg"
    done
else
    echo "Параметры: отсутствуют"
fi
