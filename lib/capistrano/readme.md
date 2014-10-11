# Deployment Notes #

## Workflow ##

### Initial setup ###

* Share your SSH key with the server to authenticate.
* Run the setup task

     bundle exec cap stage_name deploy:setup_config


Change the configuration settings in the following files

* shared/config/database.yml
* shared/config/application/mailer_config.rb
* shared/config/env_vals.rb

### Deploy ###

       bundle exec cap stage_name deploy


## Resetting configuration files ##

Delete the files that need to be reset and then run

      deploy:setup_config

This is useful when new secret_base and secret_token are needed.


## Other Notes ##

* Custom setup tasks borrowed from:
  * https://github.com/TalkingQuickly/capistrano-3-rails-template



