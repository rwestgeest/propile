FROM ruby:2.3.8-stretch

RUN apt-get update && apt-get install -y sqlite3 libsqlite3-dev build-essential nodejs
RUN apt-get install -y ruby-dev && gem install bundler --no-document

WORKDIR /app
ADD Gemfile
ADD Gemfile.lock
RUN bundle install


EXPOSE 3000
CMD rake

