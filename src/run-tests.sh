#!/bin/bash

for var in ./features/*
do
if [ -d "$var" ]&&[ -e $var/test ];
then
    flutter test $var
    if [ $? -ne 0 ];
    then
        exit 1
    fi
fi
done