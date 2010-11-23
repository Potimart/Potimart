set :stages, %w(unstable sandbox staging)
require 'capistrano/ext/multistage'

set :application, "potimart"
set :repository,  "git://potimart.dryade.priv/potimart"
set :deploy_to, "/var/www/potimart"
set :use_sudo, false

set :scm, :git

set :keep_releases, 10
after "deploy:update", "deploy:cleanup" 
after "deploy:update_code", "deploy:symlink_shared", "deploy:gems"

set :rake, "bundle exec rake"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Install gems"
  task :gems, :roles => :app do
    run "cd #{release_path} && umask 02 && bundle install #{shared_path}/bundle --without=development:test"
  end

  desc "Symlinks shared configs and folders on each release"
  task :symlink_shared, :except => { :no_release => true }  do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database_chouette.yml"
    run "ln -nfs #{shared_path}/config/production.rb #{release_path}/config/environments/"
  end
end
