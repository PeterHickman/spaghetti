#!/usr/bin/env bash

NAME=`basename $1 .bas`

./veryc $1 > ${NAME}.asm
./veryr ${NAME}.asm

rm ${NAME}.asm
