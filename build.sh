#!/bin/sh

VERSION=$(cat VERSION)

command=$1
case $command in
  push)
    docker push westghost/propile:$VERSION
    ;;
  *)
    docker build . -t westghost/propile:$VERSION
    ;;
esac

