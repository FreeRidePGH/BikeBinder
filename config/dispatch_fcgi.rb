begin
  load File.join(File.dirname(File.expand_path(__FILE__)), "env_vals.rb")
rescue LoadError; end

app_name = 'BikeBinder'
user_name = ENV['USER']
ruby_version = 'default'

ENV['RAILS_ENV'] = 'shared_host'
ENV['HOME'] ||= "/home/#{user_name}"
ENV['GEM_HOME'] = File.expand_path("/home/#{user_name}/.rvm/gems/#{ruby_version}")
ENV['GEM_PATH'] = File.expand_path("/home/#{user_name}/.rvm/gems/#{ruby_version}") + ":" +
    File.expand_path("/home/#{user_name}/.rvm/gems/#{ruby_version}@global")

require 'rubygems'
require 'bundler'
Bundler.setup(:default, :fcgi)
require 'rack'
require 'rack/protection'

class Rack::PathInfoRewriter
  def initialize(app)
    @app = app
  end
 
  def call(env)
    # Don't delete it--Rack::URLMap assumes it is not nil
    env['SCRIPT_NAME'] = ''
    pathInfo, query = env['REQUEST_URI'].split('?', 2)
    env['PATH_INFO'] = pathInfo
    env['QUERY_STRING'] = query
    @app.call(env)
  end
end

config_fpath = File.expand_path(File.join(File.dirname(__FILE__),
                                          '..', 'config.ru'))

app, options = Rack::Builder.parse_file(config_fpath)
wrappedApp = Rack::Builder.new do
  use Rack::ShowExceptions
  use Rack::PathInfoRewriter

  use Rack::Protection
  use Rack::HttpOrigin
  use Rack::Protection::SessionHijacking

  run app
end

Rack::Handler::FastCGI.run wrappedApp
