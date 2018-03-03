FROM ruby:2.3.6-jessie
WORKDIR /app

ADD Gemfile /app
ADD Gemfile.lock /app

RUN apt-get update && apt-get install -y sqlite3 libsqlite3-dev build-essential nodejs
RUN apt-get install -y ruby-dev && \
    gem install bundler --no-ri --no-rdoc && \
    cd /app ; bundle install

ADD . /app
ENV RACK_ENV production
RUN rake assets:precompile
RUN chown -R nobody /app
USER nobody
EXPOSE 3000
CMD script/run-in-docker.sh

