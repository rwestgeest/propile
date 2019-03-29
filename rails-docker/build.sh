#!/bin/bash

cp ../Gemfile* .
docker build . -t rails
rm Gemfile*
