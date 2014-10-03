# -*- mode: ruby -*-
namespace :deploy do
  desc "Setup FCGI dispatch script (and env variable values)"
  task :setup_shared_host  => [:set_rails_env]  do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          # Put fcgi files into place
          execute :cp, "#{release_path}/config/shared_host.htaccess #{release_path}/public/.htaccess"            
          execute :chmod, 755, "#{release_path}/public/dispatch.fcgi"
          
          # Provide env variable values to be read on dispatch
          if !test("[ -f #{release_path}/config/env_vals.rb ]")
            warn " the env_vals.rb file is not in place for this environment"
          end

        end # with rails_env
      end # within release_path
    end # on roles app
  end # task

end # namespace :deploy
