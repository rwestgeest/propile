set :deploy_to, "/var/www/agilesystems/#{application}-test"
set :domain, "#{user}@test.propile.xpday.net"
set :rails_env, "development"

namespace :vlad do
  desc "deploy with tests - only to=test"
  task "deploy:test" => %w{
    update
    update-bundle
    assets
    migrate
    tests
    start
  }
  desc "migrate database" 
  remote_task "tests" do
    in_current_path = "cd #{current_path} && "
    run in_current_path + "RAILS_ENV=#{environment} bundle exec rake"
  end

end
