namespace :db do
  
  desc "Prepare test database structure"
  task :test_setup => :environment do
    #ENV['RAILS_ENV'] = 'test'
    #Rake::Task['db:reset'].invoke

    ENV['RAILS_ENV'] = 'test'
    Rake::Task['db:test:load'].invoke

    ENV['FILE'] = 'surveys/bike_overhaul_inspection.rb'    
    ENV['RAILS_ENV'] = 'test'
    Rake::Task['surveyor'].invoke
  end
  
  desc "Fill database with test data"
  task :populate => :environment do
    # Preparte test db
    # http://stackoverflow.com/questions/5264355/rspec-failure-could-not-find-table-after-migration
    #Rake::Task['db:test:prepare'].invoke

    Rake::Task['db:reset'].invoke
    Rake::Task['db:seed'].invoke
    
    User.create!(:email=>"wwedler@riseup.net", :password=>"testtest")
    User.create!(:email=>"demo@freeridepgh.org", :password=>"testdemo")
    
    Rake::Task['db:populate_hooks'].invoke
    Rake::Task['db:populate_programs'].invoke
    Rake::Task['db:populate_bikes'].invoke

    # Pass rake argument using ENV hash
    ENV['FILE'] = 'surveys/bike_overhaul_inspection.rb'
    Rake::Task['surveyor'].invoke
  end
	  
  desc "Fill database with initial Hooks"
  task :populate_hooks => :environment do	
    19.times do |n|
      Hook.create!(:number=>(101+n))
      Hook.create!(:number=>(201+n))
    end
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

    arr_colors = ColorNameI18n::keys
    arr_ratings = %w[A B C D]

    arr_bike_brands = BikeBrand.all
    arr_bike_models = BikeModel.all

    arr_wheels = IsoBsdI18n::Rarity::default_division.common.sizes

    n_progs = Program.count
    n_models = BikeModel.count

    30.times do |n|

      c = arr_colors[rand(arr_colors.size)]
      val = rand(120-50)+50
      sh = rand(25-14)+14
      tl = sh+0.5

      available = (rand(2) != 1)
      prog_id = (available) ? rand(n_progs+1) : nil

      bike_model_id = rand(n_models+1)
      model = BikeModel.find(bike_model_id)
      mfg = model.brand

      quality = arr_ratings[rand(arr_ratings.length)]
      condition = arr_ratings[rand(arr_ratings.length)]

      wheel = arr_wheels[rand(arr_wheels.count)]

      b = Bike.create!(
                       :program_id => prog_id,
                       :color=>c,
                       :seat_tube_height=>sh, 
                       :top_tube_length=>tl,
                       :wheel_size => wheel,
                       :brand_id => mfg,
                       :bike_model_id => model,
                       :quality => quality,
                       :condition => condition,
                       :number => Bike.format_number(n+1001))
      if rand(3)>0
        b.reserve_hook
      end
    end  # 30.times do

  end 
end
