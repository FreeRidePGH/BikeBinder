desc "Setup/installation script to prepare applction for develoment after each pull"
task :populate => :environment do
  Rake::Task['db:drop'].invoke
  Rake::Task['setup'].invoke
  
  Rake::Task['db:populate'].invoke

  Rake::Task['db:test_setup'].invoke
end

task :populate_staging => :environment do
  # Rake::Task['db:drop'].invoke
  # Make sure the database is dropped before this task
  Rake::Task['setup'].invoke
  Rake::Task['db:bike_mfg:index_repair'].invoke
  Rake::Task['db:populate'].invoke
end

namespace :db do

  desc "Setup the application and fill database with demo data"
  task :populate => :environment do

    if User.where(:email => "demo@freeridepgh.org").count == 0
      User.create!(:email=>"demo@freeridepgh.org", :password=>"testdemo")
    end

    Rake::Task['db:populate_programs'].invoke
    Rake::Task['db:populate_destinations'].invoke
    Rake::Task['db:populate_bikes'].invoke

    # Pass rake argument using ENV hash
    ENV['FILE'] = 'surveys/bike_overhaul_inspection.rb'
    Rake::Task['surveyor'].invoke
  end
	  
  desc "Fill databse with programs"
  task :populate_programs => :environment do
    [
     {:name=>"Earn a Bike", :label=>"Earn a Bike"},
     {:name=>"Fix for Sale", :label=>"Fix for Sale"},
     {:name=>"Youth", :label=>"Youth"},
     {:name=>"Buildathon", :label=>"Buildathon"},
    ].each do |h|
      if Program.where(:name => h[:name]).count == 0
        Program.create!(h)
      else
        puts "Program '#{h[:name]}' already exists."
      end
    end # each
    
  end

  desc "Fill the database with destinations" 
  task :populate_destinations => :environment do
    [{:name => "Scrap", :label =>"scrap"},
     {:name => "As-is", :label => "As-is"}].each do |h|
      if Destination.where(:name => h[:name]).count == 0
        Destination.create!(h)
      else
        puts "Destination '#{h[:name]}' already exists."
      end
    end # each
  end

  desc "Fill database with fake Bikes"
  task :populate_bikes => :environment do

    arr_colors = Settings::Color.options #ColorNameI18n::keys
    arr_ratings = %w[a b c d f]

    arr_bike_brands = BikeBrand.all
    arr_bike_models = BikeModel.all

    arr_wheels = IsoBsdI18n::Rarity::default_division.common.sizes

    n_progs = Program.count
    n_dest = Destination.count
    n_models = BikeModel.count

    all_program = Program.all
    all_dest = Destination.all

    300.times do |n|

      c = arr_colors[rand(arr_colors.size)]
      val = rand(120-50)+50
      sh = Unit.new(rand(25-14)+14) * Unit.new('inch')
      tl = sh+Unit.new('0.5 inch')

      available = (rand(2) != 1)
      rand_prog_n = (available) ? rand(n_progs) : nil
      prog = nil || all_program[rand_prog_n] if rand_prog_n

      depart = (rand(3) != 1)
      rand_depart_n = (depart)? rand(n_dest) : nil
      dest = nil || all_dest[rand_depart_n] if rand_depart_n

      bike_model_id = BikeModel.all[rand(n_models)].id

      quality = arr_ratings[rand(arr_ratings.length)]
      condition = arr_ratings[rand(arr_ratings.length)]

      wheel = arr_wheels[rand(arr_wheels.count)]

      val = rand(120)+25

      b = Bike.create!(
                       :color=>c,
                       :seat_tube_height=>
                       Settings::LinearUnit.to_persistance_units(sh).scalar.to_f, 
                       :top_tube_length=>
                       Settings::LinearUnit.to_persistance_units(tl).scalar.to_f,
                       :wheel_size => wheel,
                       :bike_model_id => bike_model_id,
                       :quality => quality,
                       :condition => condition,
                       :value => val,
                       :number => BikeNumber.format_number(Bike.count+1))

      
      # Reserve hook
      if rand(3)>0 && Hook.next_available
        HookReservation.new(:bike => b, :hook => Hook.next_available).save
      end

      # Assign program
      if (prog)
        Assignment.build(:bike => b, :program => prog).save
      end

      # Depart
      if (dest)
        dest = nil unless prog.nil?
        Departure.build(:bike => b, :destination => dest, :value => val).save
      end

    end  # 30.times do

  end 
end
