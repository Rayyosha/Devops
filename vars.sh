#!/usr/bin/env bash
NAME="DevOps student"
TODAY=$(date +%F)
FILE="my notes.txt"
echo "Hello $NAME, today is $TODAY"
echo 'Single quotes: $NAME'
touch $FILE
ls -l "$FILE"
