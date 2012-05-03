set :deploy_to, "/var/www/agilesystems/#{application}-test"
set :domain, "#{user}@test.propile.xpday.net"
set :rails_env, "development"

namespace :vlad do
  desc "deploy with tests - only to=test"
  task "deploy:test" => %w{
    update
    assets
    migrate
    tests
    start
  }

end
