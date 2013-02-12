# Using Rails URL helpers outside of views and controllers
# http://www.johnhawthorn.com/2011/03/using-rails-url-helpers-outside-of-views-and-controllers/
# http://snipplr.com/view/37063/to-access-url-helpers-urlfor-etc-from-rails-console-rails-3/
class UrlGenerator
  include Rails.application.routes.url_helpers
  # @@default_url_options = {:host => 'www.example.com'}
  @@only_path = true
end
