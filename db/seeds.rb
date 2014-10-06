# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def generate_passwd(length=8)
  chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789!@#$%^&*)(+'
  Array.new(length) { chars[rand(chars.length)].chr }.join
end


# Seeding methodology:
#
# Seeding provides records that are minimally needed to run the application
#
# Seeding is non-destructive. An applicaiton can be re-seeded without any
# adverse effects. This means that seeding should not override existing
# records.

# Non-destructively seed the bike brand and model data
if BikeBrand.count == 0
  Rake::Task['db:bike_mfg:seed'].invoke
end

if User.count == 0
  User.create!(:email=>"staff@freeridepgh.org", :password=>generate_passwd(15), :group => 'admin')
end
if User.count == 1
  User.create!(:email=>"volunteer@freeridepgh.org", :password=>generate_passwd(15), :group => 'volunteer')
end

# Seed the hooks
(1..50).each do |n|
  ['H', 'L'].each do |suffix|
    hook_num = "%02d#{suffix}" % n
    if Hook.where(:number_record => hook_num).to_a.first.nil?    
      # Hook for the given number does not exist, so create it
      h = Hook.new
      h.number = hook_num
      h.save
    end # Hook.where
  end # [suffixes].each
end  # (1..N).each


