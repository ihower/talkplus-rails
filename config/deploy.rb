require "bundler/capistrano"

default_environment["RAILS_ENV"] = "production"
default_environment["PATH"] = "/usr/local/bin/ruby:/usr/local/bin:/usr/bin:/bin"

role :app, "www.talkpl.us"
role :web, "www.talkpl.us"
role :db,  "www.talkpl.us", :primary => true
set :rails_env, "production"

set :user, "apps"
set :branch, 'master'
set :deploy_to, "/home/apps/talkplus-rails"
set :rake, "/usr/local/bin/rake"

set :application, "talkplus-rails"
set :scm, "git"
set :repository,  "git@github.com:ihower/talkplus-rails.git"
set :deploy_via, :remote_cache
set :keep_releases, 5
set :use_sudo, false

namespace :my_tasks do
  desc "Create database.yml and asset packages"
  task :symlink, :roles => [:web] do
    symlink_hash = {
      "#{shared_path}/config/database.yml"  => "#{release_path}/config/database.yml",
    }

    symlink_hash.each do |source, target|
      run "ln -sf #{source} #{target}"
    end
  end
end

namespace :deploy do
  task :restart, :roles => [:web], :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after "deploy:update_code", "my_tasks:symlink"
after :deploy, "deploy:cleanup"