begin
  load File.join(File.dirname(File.expand_path(__FILE__)), "env_vals.rb")
rescue LoadError; end

app_name = 'BikeBinder'
user_name = ENV['USER']
ruby_version = ENV['RUBY_INTERPRETER'] || 'default'

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
require 'rack/utf8_sanitizer'

require 'airbrake'
load File.join(File.dirname(File.expand_path(__FILE__)),"initializers", "airbrake.rb")

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
begin
  app, options = Rack::Builder.parse_file(config_fpath)
rescue => ex
  ENV['airbrake.error_id'] = 
    error_id = Airbrake.notify_or_ignore(ex,cgi_data: ENV.to_hash)
  $stderr.puts "An error was sent to Airbrake with error_id: '#{ENV["airbrake.error_id"]}'"
  raise ex
end

wrappedApp = Rack::Builder.new do
  use Airbrake::Rack
  begin
    use Rack::UTF8Sanitizer
    use Rack::ShowExceptions
    use Rack::PathInfoRewriter
    use Rack::Protection::IPSpoofing
  rescue => ex
    env['airbrake.error_id'] = 
      Airbrake.notify_or_ignore(ex,cgi_data: ENV.to_hash)
    if defined? Rails
      Rails.logger.fatal "An error was sent to Airbrake with error_id: '#{env["airbrake.error_id"]}'"
    else
      $stderr.puts "An error was sent to Airbrake with error_id: '#{env["airbrake.error_id"]}'"
    end
  end

  run app
end

begin
  Rack::Handler::FastCGI.run wrappedApp
rescue => ex
  ENV['airbrake.error_id'] = 
    Airbrake.notify_or_ignore(ex,cgi_data: ENV.to_hash)
  $stderr.puts "An error was sent to Airbrake with error_id: '#{ENV["airbrake.error_id"]}'"
end
