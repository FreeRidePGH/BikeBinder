# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'BikeBinder'
set :repo_url, 'https://github.com/FreeRidePGH/BikeBinder.git'
set :branch, :master

set :rails_env, 'shared_host'
set :assets_roles, [:web, :app] 

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
set :default_env, { path: "/#{ENV['HOME']}/.rvm/bin:$PATH"}

# Default value for keep_releases is 5
set :keep_releases, 5

# Default value for :linked_files is []
set(:linked_files, 
    %w(config/database.yml
    config/application/mailer_config.rb
    config/application/secret_base.txt
    config/application/secret_token.txt
    public/.htaccess
    ))

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, 
    [
     ['database.example.yml', 'database.yml'],
     ['mailer_config.sample.rb','application/mailer_config.rb'],
     ['shared_host.htaccess','../public/.htaccess'],
     ['secret_base.txt','application/secret_base.txt'],
     ['secret_token.txt', 'application/secret_token.txt']
    ])

# which config files should be made executable after copying
# by deploy:setup_config
set(:executable_config_files, [])

# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc. The full_app_name variable isn't
# available at this point so we use a custom template {{}}
# tag and then add it at run time.
set(:system_symlinks, [])

set(:symlinks, [])

namespace :deploy do

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
