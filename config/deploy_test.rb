set :deploy_to, "/var/www/agilesystems/#{application}-test"
set :domain, "#{user}@test.propile.xpday.net"
set :rails_env, "development"
set :passenger_port, 3022

namespace :vlad do
  desc "deploy with tests - only to=test"
  task "deploy:test" => %w{
    update
    bundle
    assets
    migrate
    tests
    start
  }

  remote_task "tests", :role => :app do
    in_current_path = "cd #{current_path} && "
    run in_current_path + "bundle exec rake "
  end

  remote_task "bundle", :role => :app do
    in_current_path = "cd #{current_path} && "
    run in_current_path + "bundle install"
    
  end
end
