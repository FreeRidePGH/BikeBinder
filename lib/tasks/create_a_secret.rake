desc "Install a session secret token for the application"
task :create_a_secret =>:environment do
  require File.dirname(__FILE__) + "/../../config/directories.rb"
  puts "Writing secret token to #{APP_SECRET_FILE}"
  `rake -s secret > #{APP_SECRET_FILE}`
  puts File.exists?(APP_SECRET_FILE) ? "Succeeded" : "Failed"
end
