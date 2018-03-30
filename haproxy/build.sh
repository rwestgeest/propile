#!/bin/sh

VERSION=$(cat VERSION)

command=$1
case $command in
  push)
    docker push westghost/haproxy:$VERSION
    ;;
  *)
    docker build . -t westghost/haproxy:$VERSION
    ;;
esac

