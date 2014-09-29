

Custom setup tasks borrowed from:
https://github.com/TalkingQuickly/capistrano-3-rails-template


Workflow:

Run the setup task

     bundle exec cap stage_name deploy:setup_config


Change the configuration settings in the following files

* shared/database.yml
* shared/application/mailer_config.rb

Change permissions for dispatch.fcgi to 755
Create the .htaccess file


Reset configuration files

Delete the files that need to be reset and then run the deploy:setup_config task again.
This is useful when new secret_base and secret_token are needed.