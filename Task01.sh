#!/bin/bash

options=""
parameters=""
flag=0


for arg in "$@"; then
    if [[ flag -eq 1 ]]; then
    
    parameters+="$arg "
    elif [[ $arg == "--" ]]; then
    
    flag=1
    elif [[ $arg == -* ]]; then
    
    options+="$arg "
    else
    parameters+="$arg "
    fi
done

echo "Опции: $options"
echo "Параметры: $parameters"
