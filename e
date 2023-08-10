#!/usr/bin/env bash

TEMP=temp.$$

./dbc --input $1 --output ${TEMP}

if [ $? -ne 0 ]; then
  echo "Oops could not compile"
  exit 1
fi

./dcpu --input ${TEMP}

rm ${TEMP}
