#!/bin/sh

VERSION=$(cat VERSION)

command=$1
case $command in
  push)
    docker push wesghost/propile:$VERSION
    ;;
  *)
    docker build . -t wesghost/propile:$VERSION
    ;;
esac

