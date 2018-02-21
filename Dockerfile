FROM ruby:2.3.6-jessie
ADD Gemfile /app/
ADD Gemfile.lock /app/
RUN apt-get update && apt-get install -y sqlite3 libsqlite3-dev build-essential nodejs
RUN apt-get install -y ruby-dev && \
    gem install bundler --no-ri --no-rdoc && \
    cd /app ; bundle install
ADD . /app
RUN chown -R nobody:nogroup /app
USER nobody
ENV RACK_ENV production
EXPOSE 3000
WORKDIR /app
CMD rails db:migrate && rails s puma

