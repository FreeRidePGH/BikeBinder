
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
  ENV['RAILS_ENV'] = 'production'
  `bundle exec rake assets:precompile`

  `git add .`

  `git commit -m "vendor compiled assets"`
  
  `heroku maintenance:on`  
  `git push heroku heroku-deploy:master`
  `heroku maintenance:off`

  `git co master`

  `git branch -D heroku-deploy`
end

end
