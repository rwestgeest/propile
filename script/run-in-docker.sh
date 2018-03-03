#!/bin/sh

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

rake db:migrate
rails s puma
