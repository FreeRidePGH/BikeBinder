#
# All the magic directory constants should live here.
#

# config

CONFIG_DIRECTORY_ROOT    = File.expand_path("..", __FILE__)
APP_CONFIG_DIRECTORY     = File.join(CONFIG_DIRECTORY_ROOT, "application")
APP_SECRET_FILE          = File.join(APP_CONFIG_DIRECTORY , "secret_token.txt")
APP_SECRET_BASE_FILE     = File.join(APP_CONFIG_DIRECTORY , "secret_base.txt")
APP_MAILER_CONFIG_FILE   = File.join(APP_CONFIG_DIRECTORY, "mailer_config.rb")
APP_DB_CONFIG_FILE       = File.join(CONFIG_DIRECTORY_ROOT, "database.yml")

# tmp

TMP_DIRECTORY   = File.expand_path(File.join("..","tmp"), __FILE__)
CACHE_DIRECTORY = "#{TMP_DIRECTORY}/cache"

