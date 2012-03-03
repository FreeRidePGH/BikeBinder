namespace :db do
    desc "Fill database with test data"
    task :populate => :environment do
        Rake::Task['db:reset'].invoke
	Rake::Task['db:populate_hooks'].invoke
	Rake::Task['db:populate_bikes'].invoke

        User.create!(:email=>"wwedler@riseup.net", :password=>"testtest")
    end
	  
    desc "Fill database with initial Hooks"
    task :populate_hooks => :environment do	
       	49.times do |n|
	    Hook.create!(:number=>(101+n))
	    Hook.create!(:number=>(201+n))
	end
    end

    desc "Fill database with Bikes"
    task :populate_bikes => :environment do
        color = ['Red',
	         'Yellow',
 		 'Blue',
		 'Green', 
		 'Pink', 
		 'Orange', 
		 'White', 
		 'Silver']
        20.times do |n|
	    c = color[rand(color.size)]
	    val = rand(120-50)+50
	    sh = rand(25-14)+14
	    tl = sh+0.5
	    manufacturer = Faker::Company.name
	    fake_model = Faker::Company.bs
	    Bike.create!(
	      :color=>c,
	      :seat_tube_height=>sh, 
	      :top_tube_length=>tl,
	      :mfg => manufacturer,
	      :model => fake_model,
	      :number => n+1)
	end
    end 
	
end
