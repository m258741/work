#!/bin/bash

QRY_FILE=$1
#CONNECT_URL="mongodb://mongodb.se.maximus.com:27017"
CONNECT_URL="mongodb://mongodb.codeshuttle.maximus.com:27017"

if [ "$1" = "" ]; then
  echo "usage: $0 queryfile"
  echo "running in interactive mode..."
fi

/usr/bin/mongosh "$CONNECT_URL" -f $QRY_FILE

exit 0
