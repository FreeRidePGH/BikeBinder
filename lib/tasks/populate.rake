namespace :db do
  desc "Fill database with test data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    
    User.create!(:email=>"wwedler@riseup.net", :password=>"testtest")
    
    Rake::Task['db:populate_hooks'].invoke
    
    Rake::Task['db:populate_project_categories'].invoke         
    
    Rake::Task['db:populate_programs'].invoke
	
    Rake::Task['db:populate_bikes'].invoke
    Rake::Task['db:populate_projects'].invoke	
  end
	  
  desc "Fill database with initial Hooks"
  task :populate_hooks => :environment do	
    19.times do |n|
      Hook.create!(:number=>(101+n))
      Hook.create!(:number=>(201+n))
    end
  end

  desc "Fill databse with project categories"
  task :populate_project_categories => :environment do
    ProjectCategory.create!(:name=>"EAB", :project_type=>"Project::Eab", 
                            :max_programs=>1)
	
    ProjectCategory.create!(:name=>"Youth", 
                            :project_type=>"Project::Youth",
                            :max_programs=>3)

    ProjectCategory.create!(:name=>"Scrap",
                            :project_type=>"Project::Scrap",
                            :max_programs=>-1)
  end

  desc "Fill database with programs"
  task :populate_programs => :environment do

    youth_cat = ProjectCategory.find_by_name("Youth")
    if youth_cat
      # Create the program with constraints
      p = youth_cat.programs.create!(:title=>"Positive Spin 2012", :max_open=>5, :max_total=>10)
      p = youth_cat.programs.create!(:title=>"Grow PGH 2012",:max_total=>15)
    end
       
    eab_cat = ProjectCategory.find_by_name("EAB")
    p = eab_cat.programs.create!(:title =>"Earn-A-Bike",:max_open => 25) if eab_cat

    cat = ProjectCategory.find_by_name("Scrap")
    p = cat.programs.create!(:title=>"Shop Scrap") if cat

  end


  desc "Populate database with several fake projects"
  task :populate_projects => :environment do
    n_progs = Program.count
    total = Bike.count

    total.times do |n|

      bike = Bike.find(rand(total)+1)
      prog = Program.find(rand(n_progs)+1)
      
      if bike and prog and bike.project.nil?

        opts={:bike_id=>bike,:program_id=>prog}
	new_proj = prog.project_category.project_class.new()

	ok = new_proj.save if new_proj.assign_to(opts)
        
        if rand(4)<1
          new_proj.close(:depart=>true)
        end
      end
      
    end
  end
  
  
  desc "Fill database with fake Bikes"
  task :populate_bikes => :environment do

    require File.dirname(__FILE__)+'/bike_data'
   
    n_options = mfgr.length

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

      n_bike_info = rand(n_options)

      #manufacturer = Faker::Company.name
      #fake_model = Faker::Company.bs

      manufacturer = mfgr[n_bike_info]
      fake_model = model[n_bike_info]

      b = Bike.create!(
                       :color=>c,
                       :seat_tube_height=>sh, 
                       :top_tube_length=>tl,
                       :mfg => manufacturer,
                       :model => fake_model,
                       :number => Bike.format_number(n+1001))
      if rand(3)>0
        b.reserve_hook!
      end
    end
  end 
end
