desc "Setup/installation script to prepare applction for develoment after each pull"
task :populate => :environment do
  Rake::Task['db:drop'].invoke
  Rake::Task['setup'].invoke
  
  Rake::Task['db:populate'].invoke

  Rake::Task['db:test_setup'].invoke
end

task :populate_staging => :environment do
  #Rake::Task['db:drop'].invoke
  `heroku pg:reset OLIVE --confirm bikebinder`
  Rake::Task['setup'].invoke
  Rake::Task['db:bike_mfg:index_repair'].invoke
  Rake::Task['db:populate'].invoke
end

namespace :db do

  desc "Setup the application and fill database with demo data"
  task :populate => :environment do

    Rake::Task['db:populate_programs'].invoke
    Rake::Task['db:populate_bikes'].invoke

    # Pass rake argument using ENV hash
    ENV['FILE'] = 'surveys/bike_overhaul_inspection.rb'
    Rake::Task['surveyor'].invoke
  end
	  
  desc "Fill databse with programs"
  task :populate_programs => :environment do
    Program.create!(:name=>"Earn a Bike", :label=>"Earn a Bike")
    Program.create!(:name=>"Fix for Sale", :label=>"Fix for Sale")
    Program.create!(:name=>"Youth", :label=>"Youth")
    Program.create!(:name=>"Scrap", :label=>"Scrap")
    Program.create!(:name=>"Buildathon", :label=>"Buildathon")
    Program.create!(:name=>"As-Is", :label=>"As-Is")
    Program.create!(:name=>"Northview", :label=>"Northview")
  end

  desc "Fill database with fake Bikes"
  task :populate_bikes => :environment do

    arr_colors = Settings::Color.options #ColorNameI18n::keys
    arr_ratings = %w[a b c d f]

    arr_bike_brands = BikeBrand.all
    arr_bike_models = BikeModel.all

    arr_wheels = IsoBsdI18n::Rarity::default_division.common.sizes

    n_progs = Program.count
    n_models = BikeModel.count

    30.times do |n|

      c = arr_colors[rand(arr_colors.size)]
      val = rand(120-50)+50
      sh = Unit.new(rand(25-14)+14) * Unit.new('inch')
      tl = sh+Unit.new('0.5 inch')

      available = (rand(2) != 1)
      rand_prog_n = (available) ? rand(n_progs) : nil
      prog_id = nil
      prog_id = Program.all[rand_prog_n].id if rand_prog_n

      bike_model_id = BikeModel.all[rand(n_models)].id

      quality = arr_ratings[rand(arr_ratings.length)]
      condition = arr_ratings[rand(arr_ratings.length)]

      wheel = arr_wheels[rand(arr_wheels.count)]

      b = Bike.create!(
                       #:program_id => prog_id,
                       :color=>c,
                       :seat_tube_height=>
                       Settings::LinearUnit.to_persistance_units(sh).scalar.to_f, 
                       :top_tube_length=>
                       Settings::LinearUnit.to_persistance_units(tl).scalar.to_f,
                       :wheel_size => wheel,
                       :bike_model_id => bike_model_id,
                       :quality => quality,
                       :condition => condition,
                       :number => BikeNumber.format_number(n+1001))

      if rand(3)>0
        # b.reserve_hook
      end
    end  # 30.times do

  end 
end
