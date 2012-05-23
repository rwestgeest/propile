set :application, "propile"
set :repository,  "git://github.com/rwestgeest/propile.git"
set :user, "agilesystems"
shared_paths['data'] = 'data'
shared_paths['assets'] = 'public/assets'
ENV['to'] = 'test' unless ENV['to']


namespace :vlad do

  set :migrate_target, :current
  desc "Deploy application"
  task "deploy" => %w{
    update
    update-bundle
    assets
    start
  }
  desc "deploy and migrate"
  task "deploy:migrate" => %w{
    update
    update-bundle
    assets
    migrate
    start
  }

  desc "update the bundle"
  remote_task "update-bundle" do
    in_current_path = "cd #{current_path} && " 
    run in_current_path + "bundle install"
  end

  desc "generate assets"
  remote_task "assets" do
    in_current_path = "cd #{current_path} && "
    run in_current_path + "RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end

  desc "migrate database" 
  remote_task "migrate", :role => :app  do
    in_current_path = "cd #{current_path} && "
    run in_current_path + "RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
  end

  desc "start stand alone passenger server" 
  remote_task "start" do
    in_current_path = "cd #{current_path} && "
    begin 
      run in_current_path + "passenger stop -p #{passenger_port}" 
    rescue 
    end
    run in_current_path + "which passenger"

    run in_current_path + "RAILS_ENV=#{rails_env} passenger start -a 127.0.0.1 -p #{passenger_port} -d"
  end

end


