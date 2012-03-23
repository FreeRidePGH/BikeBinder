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
       ProjectCategory.create!(:name=>"Eab")
       ProjectCategory.create!(:name=>"Youth")
    end

    desc "Fill database with programs"
    task :populate_programs => :environment do
       youth_cat = ProjectCategory.find_by_name("Youth")
       p = youth_cat.programs.create!(:title=>"Positive Spin 2012") \
       unless youth_cat.nil?
       p = youth_cat.programs.create!(:title=>"Grow PGH 2012", :max_total=>15)\
       unless youth_cat.nil?
       
       eab_cat = ProjectCategory.find_by_name("Eab")
       p = eab_cat.programs.create!(:title =>"Earn-A-Bike", :max_open => 25)\
       unless eab_cat.nil?
    end


    desc "Populate database with several fake projects"
    task :populate_projects => :environment do
    	 n_progs = Program.count
    	 total = Bike.count

    	 total.times do |n|
   	   bike = Bike.find(rand(total)+1)
   
	   prog = Program.find(rand(n_progs)+1)

	   if bike and prog and bike.project.nil?
	      proj_cat = prog.project_category
	      proj_type = "Project::" + proj_cat.name
              @project = proj_type.constantize

	      new_proj = @project.new()
	      
	      prog.projects << new_proj
	      prog.save

	      bike.project = new_proj
	      bike.save

              new_proj.project_category  = proj_cat
              new_proj.save
	   end
	    
	 end
    end


    desc "Fill database with fake Bikes"
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
