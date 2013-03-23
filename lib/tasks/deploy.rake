namespace :deploy do

  desc 'Deploy to the staging environment on Heroku'
  task :staging do
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

    if `heroku config:get SECRET_TOKEN`.length<30
      puts "Configuring the secret token on the staging deployment"
      secret = `heroku run rake -s secret`.strip
      `heroku config:add BIKE_BINDER_SECRET_TOKEN=#{secret}`
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
