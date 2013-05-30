def check_source_control
    unless `git status -s`.length == 0
      puts 'WARNING: There are uncommitted changes'
      puts 'Commit any changes before deploying.'
      exit
    end
end

def check_secret_token
  if `heroku config:get BIKE_BINDER_SECRET_TOKEN`.length<30
    puts "Configuring the secret token on the staging deployment"
    secret = `rake -s secret`.strip
    `heroku config:set BIKE_BINDER_SECRET_TOKEN=#{secret}`
  end
end

def precompile_deploy_assets
    `git co -b heroku-deploy`
    `git co heroku-deploy`
    `git merge master`
    `git pull heroku master`
    `git rm public/assets/manifest.yml`
    ENV['RAILS_ENV'] = 'production'
    `bundle exec rake assets:precompile`
    
    `git add .`

    `git commit -m "vendor compiled assets"`
    `git push heroku heroku-deploy:master`
end

def cleanup_deploy_steps
    `git co master`
    `git branch -D heroku-deploy`
end

namespace :deploy do

  desc 'Deploy to the production environment on Heroku'
  task :production do
    
    check_source_control
    `heroku maintenance:on`  
    check_secret_token
    precompile_deploy_assets    
    
    puts "Setup and populate the staging deployment"
    `heroku run rake populate_staging`
    `heroku maintenance:off`
    cleanup_deploy_steps
  end

  desc 'Deploy to the staging environment on Heroku'
  task :staging do
      exit
    
    unless `git status -s`.length == 0
      puts 'WARNING: There are uncommitted changes'
      puts 'Commit any changes before deploying.'
      exit
    end
    
    `git co -b heroku-deploy`
    `git co heroku-deploy`
    `git merge master`
    `git pull heroku master`
    `git rm public/assets/manifest.yml`
    ENV['RAILS_ENV'] = 'production'
    `bundle exec rake assets:precompile`
    
    `git add .`

    `heroku maintenance:on`  

    if `heroku config:get BIKE_BINDER_SECRET_TOKEN`.length<30
      puts "Configuring the secret token on the staging deployment"
      secret = `rake -s secret`.strip
      `heroku config:set BIKE_BINDER_SECRET_TOKEN=#{secret}`
    end
    
    `git commit -m "vendor compiled assets"`
    `git push heroku heroku-deploy:master`

    puts "Reset the deploy database"
    `heroku pg:reset OLIVE --confirm bikebinder`

    puts "Setup and populate the staging deployment"
    `heroku run rake populate_staging`

    `heroku maintenance:off`
    
    `git co master`

    `git branch -D heroku-deploy`
  end
  
end
