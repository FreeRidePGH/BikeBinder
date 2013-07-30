def check_source_control
    unless `git status -s`.length == 0
      puts 'WARNING: There are uncommitted changes'
      puts 'Commit any changes before deploying.'
      exit
    end
end

def check_secret_token
  token =  Bundler.with_clean_env{`heroku config:get BIKE_BINDER_SECRET_TOKEN`}
  if token.length<30
    puts "Configuring the secret token on the staging deployment"
    secret = Bundler.with_clean_env{`rake -s secret`}.strip
    Bundler.with_clean_env{puts `heroku config:set BIKE_BINDER_SECRET_TOKEN=#{secret}`}
  end

  base = Bundler.with_clean_env{`heroku config:get BIKE_BINDER_SECRET_BASE`}
  if base.length<30
    puts "Configuring the cookie store base on the staging deployment"
    secret = Bundler.with_clean_env{`rake -s secret`}.strip
    Bundler.with_clean_env{puts `heroku config:set BIKE_BINDER_SECRET_BASE=#{secret}`}
  end
end

def precompile_deploy_assets
  puts `git co -b heroku-deploy`
  puts `git co heroku-deploy`
  puts `git merge master`
  puts `git pull heroku master`
  puts `git rm public/assets/manifest-*.json`
  ENV['RAILS_ENV'] = 'production'
  Bundler.with_clean_env{puts `bundle exec rake assets:clobber`}
  Bundler.with_clean_env{puts `bundle exec rake assets:precompile`}
    
  puts `git add .`

  puts `git commit -m "vendor compiled assets"`
  puts `git push heroku heroku-deploy:master`
end

def cleanup_deploy_steps
  puts `git co master`
  puts `git branch -D heroku-deploy`
end

namespace :deploy do

  desc 'First (Cold) deploy to the production environment on Heroku'
  task :production_cold do
    
    check_source_control
    Bundler.with_clean_env{puts `heroku maintenance:on`}
    check_secret_token
    precompile_deploy_assets    
    
    puts "Setup and seed the production deployment"
    Bundler.with_clean_env{`heroku run rake populate_production_cold`}
    Bundler.with_clean_env{puts `heroku maintenance:off`}
    cleanup_deploy_steps
  end

  desc 'Deploy to the production environment on Heroku'
  task :production do
    check_source_control
    Bundler.with_clean_env{puts `heroku maintenance:on`}
    check_secret_token
    precompile_deploy_assets    
    
    puts "Setup and seed the production deployment"
    Bundler.with_clean_env{`heroku run rake populate_production`}
    Bundler.with_clean_env{puts `heroku maintenance:off`}
    cleanup_deploy_steps
  end

  desc 'Deploy to the staging environment on Heroku'
  task :staging do
    exit
    
    check_source_control
    Bundler.with_clean_env{`heroku maintenance:on`}
    check_secret_token
    precompile_deploy_assets    

    `git commit -m "vendor compiled assets"`
    `git push heroku heroku-deploy:master`

    puts "Reset the deploy database"
    Bundler.with_clean_env{`heroku pg:reset OLIVE --confirm bikebinder`}

    puts "Setup and populate the staging deployment"
    Bundler.with_clean_env{`heroku run rake populate_staging`}

    Bundler.with_clean_env{`heroku maintenance:off`}
    cleanup_deploy_steps
  end
  
end
