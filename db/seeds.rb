# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Non-destructively seed the bike brand and model data
if BikeBrand.count == 0
  Rake::Task['db:bike_mfg:seed'].invoke
end

if User.count == 0
  User.create!(:email=>"demo@freeridepgh.org", :password=>"testdemo")
end

(1..80).each do |n|
  ['H', 'L'].each do |suffix|
    hook_num = "#{n}#{suffix}"

    if Hook.where{number == my{hook_num}}.first.nil?    
      # Hook for the given number does not exist, so create it
      h = Hook.new
      h.number = hook_num
      h.save
    end # Hook.where
  end # [suffixes].each
end  # (1..N).each
