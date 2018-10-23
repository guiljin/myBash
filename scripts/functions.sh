#!/bin/bash

bbwarn(){
    echo -e "\e[33;1m$1\e[0m"
}

bberror(){
    echo -e "\e[31;1m$1\e[0m"
}

catall(){
    for file in  $@
    do
        echo -e "\e[33;1m$file\e[0m"
        cat $file
    done
}