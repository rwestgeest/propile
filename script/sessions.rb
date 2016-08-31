#!/usr/bin/env ruby

ENV["RAILS_ENV"] ||= 'development'
require File.expand_path("../../config/environment", __FILE__)
require 'tasks/sessions'

ThorScripts::Sessions.start
