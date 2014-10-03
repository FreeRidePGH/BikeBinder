begin
  load File.join(File.dirname(File.expand_path(__FILE__)), "env_vals.rb")
rescue LoadError; end

app_name = 'BikeBinder'
user_name = 'frpgh'
ruby_version = 'ruby-2.0.0-p247'

ENV['RAILS_ENV'] = 'shared_host'
ENV['HOME'] ||= "/home/#{user_name}"
ENV['GEM_HOME'] = File.expand_path("/home/#{user_name}/.rvm/gems/#{ruby_version}")
ENV['GEM_PATH'] = File.expand_path("/home/#{user_name}/.rvm/gems/#{ruby_version}") + ":" +
    File.expand_path("/home/#{user_name}/.rvm/gems/#{ruby_version}@global")

require 'rubygems'
require 'bundler'
Bundler.setup(:default, :fcgi)
require 'rack'

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
  run app
end

Rack::Handler::FastCGI.run wrappedApp

# require 'fcgi'
# require File.join(File.dirname(__FILE__), '../config/environment')
 
#class Rack::PathInfoRewriter
# def initialize(app)
#   @app = app
# end
 
# def call(env)
#   env.delete('SCRIPT_NAME')
#   parts = env['REQUEST_URI'].split('?')
#   env['PATH_INFO'] = parts[0]
#   env['QUERY_STRING'] = parts[1].to_s
#   @app.call(env)
# end
#end
 
#Rack::Handler::FastCGI.run  Rack::PathInfoRewriter.new(Object.const_get(app_name)::Application)


