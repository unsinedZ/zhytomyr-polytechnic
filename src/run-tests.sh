#!/bin/bash

for var in ./features/*
do
if [ -d "$var" ]&&[ -e $var/test ]
then
flutter test $var
fi
done