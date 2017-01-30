# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'rubygems'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'factory_girl_rails'
require 'shoulda/matchers'
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.include ControllerExtensions, :type => :controller
  config.include Shoulda::Matchers::ActiveModel
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  config.filter_run_including :focus => true
  config.filter_run_excluding :broken => true
  config.filter_run 
  config.run_all_when_everything_filtered = true
end

 load_schema = lambda {  
   load "#{Rails.root.to_s}/db/schema.rb" # use db agnostic schema by default  
 }
 silence_stream(STDOUT, &load_schema)
