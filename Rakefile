#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
require 'bundler'
Bundler.require :rake
begin
  require "vlad"
  Vlad.load(:app => nil, :scm => "git", :web => nil)
rescue LoadError
  # do nothing
end


require File.expand_path('../config/application', __FILE__)

Propile::Application.load_tasks

desc "release version defined in VERSION" 
task "release" do
  releaseline = File.readlines('VERSION').first.strip
  p releaseline
  version = releaseline[/[^\s]*/] 
  raise "Version #{version} has invalid format" unless version =~ /\d*\.\d*.\d*/
  raise "Tag #{version} was released earlier" if `git tag`.split.include?(version)
  message = "Released " + releaseline
  sh "git tag -a -m '#{message}' #{version}"
  sh 'rake vlad:deploy:migrate to=prod'
end

desc "Get the production database to local development"
task "get_prod_db" do
  sh 'scp agilesystems@propile.xpday.net:propile-prod/data/production.sqlite3 data/development.sqlite3'
end

desc "Get the production database to remote test"
task "get_prod_db_to_test" do
  sh 'ssh agilesystems@propile.xpday.net cp -v propile-test/data/development.sqlite3 propile-test/data/development.sqlite3.backup'
  sh 'ssh agilesystems@propile.xpday.net cp -v propile-prod/data/production.sqlite3 propile-test/data/development.sqlite3'
end
