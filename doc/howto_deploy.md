# How to deploy the system 

## One time Preparation

## Do not forget

* run your test
* commit the code
* push the code

## Staging

We have two invironments 

* test 
  test is meant for acceptance testing purposes
  test runs in rails development mode

* production
  production is meant for production
  production runs in rails productio mode


## Deploy tasks

We deploy with vlad. Vlad uses rake.

when deploying, by default all is deployed to the test environment

"rake vlad:deploy" deploys to test

to deploy to production use the to=prod argument

"rake vlad:deploy to=prod deploys to production

Use rake -T to list all the rake tasks. Rake tasks that start with vlad:
are deployment tasks

## Typical workflow

After implementing a (part of a) feature you check in and push the code
and then

### deploy to test

Typically i would deploy to test and run the tests as well.

So I would 

rake vlad:deploy:test

This deploys the code, installs missing packages, runs the migrations,
runs the tests and restarts the server

### deploy to production

After being setisfied with the feature (accepted) 

I sould 

rake vlad:deploy:migrate to=prod



