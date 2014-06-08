# -*- mode: ruby -*-

# Given a list of bike numbers of the bikes that are actually
# in the shop, find the bikes that are not "departed" and add
# them to a list of bikes that 'went missing'
def went_missing(numbers_in_the_shop)
  BikeReport.new(:present => true).assets.select do |b|
    numbers_in_the_shop.index(b.number.to_s).nil?
  end
end

# Given a list of bike numbers of the bikes that are actually
# in the shop, find the bikes that are "departed" and add them
# to a list of bikes that are 'still here'
def still_here(numbers_in_the_shop)
  BikeReport.new(:departed => true).assets.select do |b|
    numbers_in_the_shop.index(b.number.to_s)
  end
end

desc "Place all missing bikes as departed unknown"
task :cleanup_missing => :environment do

  # depart all of the bikes that are not in the shop, but are still recorded as in the shop
  dest_unknown = Destination.where(:name => "Unknown").first
  if !dest_unknown
    puts "No destination 'Unknon' exists"
  end
  went_missing(bikes_actually_in_the_shop).each do |b|
    departure = Departure.build(:bike => b, :value => b.value || 0 , :destination => dest_unknown)
    if ! departure.save
      puts "Could not depart bike #{b.number}"      
      puts departure.errors.messages
    end
  end

  # return all the bikes that were found in the shop but are recorded as departed
  still_here(bikes_actually_in_the_shop).each do |b|
    if !  b.departure.destroy
      puts "Could not return bike #{b.number}"
      puts b.departure.errors.messages
    end
  end
  
end

desc "Reset the hooks by deleting them all and then re-seeding"
task :cleanup_reset_hooks => :environment do
  Hook.destroy_all
  Rake::Task['db:seed'].invoke
end # task :cleanup_reset_hooks => :environment

desc "Assign all hooks to the bikes actually on them"
task :cleanup_hooks => :environment do
  # On each hook, make sure the assigned bike
  # matches what is actually there

  hook_actual_assignments.each do |h_num, b_num|
    hook = Hook.where(:number_record => h_num).first

    if hook.nil?
      puts "Hook not found for number #{h_num}"
    end
	
    if b_num.nil?
      if hook && hook.reservation
        if !hook.reservation.delete
          puts "Hook #{hook.number} could not be freed"
        end
      end
    else
      bike = Bike.where(:number_record => b_num).first
      
      if bike.nil?
        puts "Bike not found for number #{b_num}"
      end
      
      if bike && hook
        # Case the correct bike is already there
        if hook.bike && hook.bike.number.to_s == b_num
          # nothing to do
        else
          if bike.hook
            # Case the bike is on a different hook
            # leave the hook
            if !bike.hook_reservation.delete
              puts "Bike #{bike.number} could not leave hook #{bike.hook.number}"
              puts bike.hook_reservation.errors.messages
            end
          end
          
          if hook.bike
            # Case an incorrect bike is on the hook
            # remove the bike
            if !hook.reservation.delete
              puts "Bike #{hook.bike.number} could not leave hook #{hook.number}"
              puts hook.hook_reservation.errors.messages
            end
          end
          
          # The bike should have no hook and the hook should have no bike
          # Add the bike to the hook
          reservation = HookReservation.new(:bike => bike, :hook => hook)
          if !reservation.save
            puts  "Bike #{bike.number} could not take hook #{hook.number}"
            puts reservation.errors.messages
          end
          
        end # else hook.bike.number.to_s == b_num
      end # bike && hook
    end # else b_num.nil?
      
  end # hook_actuall_assignment.each
end # task :cleanup_hooks


def hook_actual_assignments
  { "01H" => "02072",
    "01L" => "02010",
    "02H" => "02023",
    "02L" => "02000",
    "03H" => nil,
    "03L" => "02009",
    "04H" => nil,
    "04L" => "02046",
    "05H" => "02101",
    "05L" => "02078",
    "06H" => "02100",
    "06L" => "01823",
    "07H" => "01886",
    "07L" => "01586",
    "08H" => "01870",
    "08L" => "01889",
    "09H" => "00851",
    "09L" => "01998",
    "10H" => "01996",
    "10L" => "01801",
    "11H" => "02099",
    "11L" => "02059",
    "12H" => "02097",
    "12L" => "01905",
    "13H" => "01609",
    "13L" => "02037",
    "14H" => "02067",
    "14L" => "02036",
    "15H" => "01657",
    "15L" => "01923",
    "16H" => "01849",
    "16L" => "01831",
    "17H" => "02096",
    "17L" => "01802",
    "18H" => "00753",
    "18L" => "02090",
    "19H" => "02003",
    "19L" => "02082",
    "20H" => "02055",
    "20L" => "02061",
    "21H" => "02068",
    "21L" => "01719",
    "22H" => "02056",
    "22L" => "01878",
    "23H" => "02051",
    "23L" => "02092",
    "24H" => "02106",
    "24L" => "01692",
    "25H" => "01875",
    "25L" => "02087",
    "26H" => "02050",
    "26L" => "01834",
    "27H" => "01910",
    "27L" => "02086",
    "28H" => "01411",
    "28L" => "01985",
    "29H" => "01685",
    "29L" => "01615",
    "30H" => "01919",
    "30L" => "01858",
    "31H" => "01593",
    "31L" => "01907",
    "32H" => nil,
    "32L" => "02073",
    "33H" => "00415",
    "33L" => "01853",
    "34H" => nil,
    "34L" => "01873",
    "35H" => "01768",
    "35L" => "02047",
    "36H" => nil,
    "36L" => "02021",
    "37H" => "01947",
    "37L" => "01037",
    "38H" => "01917",
    "38L" => "01732",
    "39H" => "01757",
    "39L" => "02071",
    "40L" => "01585",
    "41H" => nil,
    "41L" => "02020",
    "42H" => "02060",
    "42L" => "02093",
    "43H" => "02089",
    "43L" => "01794",
    "44H" => nil,
    "44L" => "01819",
    "45H" => nil,
    "45L" => "01948",
    "46H" => "01994",
    "46L" => "02004",
    "47H" => "02069",
    "47L" => "02085",
    "48H" => "01734",
    "48L" => "02105",
    "49H" => "02040",
    "49L" => "02080",
    "50H" => "02081",
    "50L" => "01840"
  }
end

def bikes_actually_in_the_shop
  ["00415",
   "00485",
   "00753",
   "00851",
   "01037",
   "01108",
   "01373",
   "01404",
   "01411",
   "01511",
   "01585",
   "01586",
   "01593",
   "01609",
   "01615",
   "01657",
   "01659",
   "01685",
   "01692",
   "01719",
   "01732",
   "01734",
"01757",
"01768",
"01794",
"01801",
"01802",
"01809",
"01819",
"01823",
"01830",
"01831",
"01834",
"01840",
"01849",
"01853",
"01858",
"01867",
"01870",
"01873",
"01875",
"01878",
"01886",
"01889",
"01905",
"01907",
"01910",
"01914",
"01917",
"01919",
"01923",
"01947",
"01948",
"01960",
"01961",
"01962",
"01963",
"01964",
"01966",
"01969",
"01985",
"01994",
"01996",
"01998",
"02000",
"02003",
"02004",
"02008",
"02009",
"02010",
"02011",
"02017",
"02019",
"02020",
"02021",
"02023",
"02025",
"02026",
"02027",
"02029",
"02036",
"02037",
"02038",
"02040",
"02046",
"02047",
"02050",
"02051",
"02053",
"02054",
"02055",
"02056",
"02059",
"02060",
"02061",
"02067",
"02068",
"02069",
"02071",
"02072",
"02073",
"02075",
"02078",
"02080",
"02081",
"02082",
"02085",
"02086",
"02087",
"02088",
"02089",
"02090",
"02092",
"02093",
"02096",
"02097",
"02099",
"02100",
"02101",
"02103",
"02105",
"02106",
"02115",
]
end
