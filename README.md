# propile

Community Conference Program Compiler

## Getting started

Make sure you have ruby 2.`* installed.

Clone the directory and run:

~~~.bash
bundle install
~~~

Use:

~~~.bash
rake db:setup
~~~

to reate a development database (sqlite) in the data directory.

Then start:

~~~.bash
rails serve
~~~

Open a browser on `http://localhost:3000`

You should be able to login with:

username `admin@test.it`
password `s3cr3t`

## When running the site locally

### Recaptcha on local

The recaptcha keys are generated for specific domains (xpdays.net and
propile.local). It is not possible to use recapcha for localhost. 

Therefore,
edit your `/etc/hosts` or `c:\Windows\System32\Drivers\hosts` file and
make sure propile.local points to localhost.

Use `http://propile.local:3000 in your browser and you should be able to
submit sessions.

### Mails 

Session submitters (potential presenters are get an email with a link,
confirming their account on submitting their first session. Mails are
not sent when running propile in development mode. 

However you can, if you want, check the log file `log/development.log`
to the mail content, extract the confirmation link and paste it in the
browser.
a 




