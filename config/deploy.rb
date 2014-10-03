# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'BikeBinder'
set :repo_url, 'https://github.com/FreeRidePGH/BikeBinder.git'
set :branch, :master

set :rails_env, 'shared_host'
# set :assets_roles, [:web] 

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'
# Set this in the production/staging file (WW)

# Default value for :scm is :git
set :scm, :git

set :use_sudo, false

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, false

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/#{ENV['HOME']}/.rvm/bin:$PATH"}

# Default value for keep_releases is 5
set :keep_releases, 5

# Default value for :linked_files is []
set(:linked_files, 
    %w(config/database.yml
    config/application/mailer_config.rb
    config/application/secret_base.txt
    config/application/secret_token.txt
    config/env_vals.rb
    ))

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, 
    [
     ['database.example.yml', 'config/database.yml'],
     ['mailer_config.sample.rb','config/application/mailer_config.rb'],
     ['secret_base.txt','config/application/secret_base.txt'],
     ['secret_token.txt', 'config/application/secret_token.txt'],
     ['env_vals.rb', 'config/env_vals.rb']
    ])

namespace :deploy do

  task :fix_assets_precompile => [:set_rails_env]  do
    on roles(fetch(:assets_roles)) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          warn '!!!!!!!!!!!'
          execute :mkdir, "-p #{release_path}/public/assets"            
          execute :touch, "#{release_path}/public/assets/manifest.json" 
        end
      end
    end
  end

  before :updated, :fix_assets_precompile
  after :updated, :setup_shared_host

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
