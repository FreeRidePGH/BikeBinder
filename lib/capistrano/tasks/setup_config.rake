# -*- mode: ruby -*-

namespace :deploy do
  desc "upload files to shared/config, then set exec and symlinks as configured"
  task :setup_config do
    on roles(:app) do
      # make the config dir
      execute :mkdir, "-p #{shared_path}/config"
      full_app_name = fetch(:full_app_name)

      # config files to be uploaded to shared/config, see the
      # definition of smart_template for details of operation.
      # Essentially looks for #{filename}.erb in deploy/#{full_app_name}/
      # and if it isn't there, falls back to deploy/#{shared}. Generally
      # everything should be in deploy/shared with params which differ
      # set in the stage files
      config_files = fetch(:config_files)
      config_files.each do |file|
        if file.respond_to?('each')&&file.respond_to?('[]')
          if (subdir = File.dirname(file[1])) != '.'
            execute :mkdir, "-p #{shared_path}/config/#{subdir}"            
          end
          smart_template file[0], file[1]
        else
          smart_template file
        end
      end

      # which of the above files should be marked as executable
      executable_files = fetch(:executable_config_files)
      executable_files.each do |file|
        execute :chmod, "+x #{shared_path}/config/#{file}"
      end

      # symlink stuff which should be... symlinked
      symlinks = fetch(:system_symlinks)
      symlinks.each do |symlink|
        execute "ln -nfs #{shared_path}/config/#{symlink[:source]} #{sub_strings(symlink[:link])}"
      end

      # Symlinks that are relative to current_path
      symlinks = fetch(:symlinks)      
      symlinks.each do |symlink|
        execute "ln -nfs #{shared_path}/config/#{symlink[:source]} #{current_path}/#{sub_strings(symlink[:link])}"
      end
    end
  end
end
