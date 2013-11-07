propile
=======

Community Conference Program Compiler


## Installation

Some environment variables are needed to set up the app :

* `PROPILE_DEV_DB_NAME`
* `PROPILE_DEV_DB_USER`
* `PROPILE_DEV_DB_PASS`
* `PROPILE_TEST_DB_NAME`
* `PROPILE_TEST_DB_USER`
* `PROPILE_TEST_DB_PASS`
* `PROPILE_PROD_DB_NAME`
* `PROPILE_PROD_DB_USER`
* `PROPILE_PROD_DB_PASS`

You only need the first six for a development environment, set them in your
.bashrc, .tmuxrc, or whatever you want than will set environment variables for
your application.

To create databases :

    $ sudo -u postgres psql

    postgres=# create database <PROPILE_DEV_DB_NAME>;
    postgres=# create user <PROPILE_DEV_DB_USER> with password '<PROPILE_DEV_DB_PASS>';
    postgres=# grant all privileges on database <PROPILE_DEV_DB_NAME> to <PROPILE_DEV_DB_USER>;
    postgres=# create database <PROPILE_TEST_DB_NAME>;
    postgres=# create user <PROPILE_TEST_DB_USER> with password '<PROPILE_TEST_DB_PASS>';
    postgres=# grant all privileges on database <PROPILE_TEST_DB_NAME> to <PROPILE_TEST_DB_USER>;
    postgres=# ^d

    $ bundle exec rake db:migrate
    $ RAILS_ENV=test bundle exec rake db:migrate

Then, ensure tests are passing :

    bundle exec rspec spec/
