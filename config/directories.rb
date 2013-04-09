#
# All the magic directory constants should live here.
#

dirs = []

# config

dirs << CONFIG_DIRECTORY_ROOT = "#{Rails.root}/config"
dirs << APP_CONFIG_DIRECTORY = "#{Rails.root}/config/application"
APP_SECRET_FILE              = "#{APP_CONFIG_DIRECTORY}/secret_token.txt"
APP_DB_CONFIG_FILE            = "#{CONFIG_DIRECTORY_ROOT}/database.yml"
APP_MAILER_CONFIG_FILE       = "#{APP_CONFIG_DIRECTORY}/mailer_config.rb"

# tmp

dirs << TMP_DIRECTORY   = "#{Rails.root}/tmp"
dirs << CACHE_DIRECTORY = "#{TMP_DIRECTORY}/cache"

#
# ensure the directories exist
#

require 'fileutils'

dirs.each do |dir|
  unless File.directory?(dir)
    if File.exists?(dir)
      raise 'ERROR: %s is supposed to be a directory, but file already exists' % dir
    else
      FileUtils.mkdir_p(dir)
    end
  end
end

