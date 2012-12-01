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

  workbook = RubyXL::Parser.parse("public/BikeInventory.xlsx")
  worksheet = workbook[0].extract_data
  require 'set'
  brands = Hash.new
  
  desc "Fill database with test data"
  task :populate => :environment do
    # Preparte test db
    # http://stackoverflow.com/questions/5264355/rspec-failure-could-not-find-table-after-migration
    #Rake::Task['db:test:prepare'].invoke

    Rake::Task['db:reset'].invoke
    
    User.create!(:email=>"wwedler@riseup.net", :password=>"testtest")
    User.create!(:email=>"demo@freeridepgh.org", :password=>"testdemo")
    
    Rake::Task['db:populate_hooks'].invoke
    
    Rake::Task['db:populate_programs'].invoke
	  Rake::Task['db:populate_brands'].invoke
    Rake::Task['db:populate_bike_models'].invoke
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

  
  desc "Populate database with several fake brands"
  task :populate_brands => :environment do
    #for i in 1..3
      #manufacturer = Faker::Company.name
      #fake_model = Faker::Company.bs

      #manufacturer = mfgr[n_bike_info]
      #fake_model = model[n_bike_info]
      #brand = Brand.create!(:name =>  Faker::Company.name + " #{i}")
    #end
    i = 0
    while(i < worksheet.length - 1)
      i += 1
      br = worksheet[i][15]
      if(br == nil || br == "")
        next
      end
      br = String(br)
      if(brands[br] == nil)
        brands[br] = [i-1, Set.new]
        brand = Brand.create!(:name =>  br)
      end
      mdl = worksheet[i][16]
      if(mdl == nil || mdl == "")
        next
      end
      mdl = String(mdl)
      (brands[br][1]).add mdl
    end
  end
 
  desc "Populate database with several fake models"
  task :populate_bike_models => :environment do
    #for i in 1..3
      #bm = BikeModel.create!(:name => Faker::Company.bs + " #{i}",
                             #:brand_id => i)
    #end
    
    brands.each_key{|br|
      (brands[br][1]).each{|mdl| bm = BikeModel.create!(:name => mdl, :brand_id => brands[br][0])}
    }
  end
  
  def froat(x, metric)
    if x == nil
      return nil
    end
    if (String(x) =~ /(\d*\.?\d*)\D/)
      t = $1
      if(t.length < 1)
        return 0
      end
      t = Float(t)
      if(metric)
        if(t < 40)
          t = t * 25.4
        elsif(t < 100)
          t = t * 10
        end
      else
        if(t > 100)
          t = t / 25.4
        elsif(t >= 40)
          t = t / 2.54
        end
      end
      return t
    end
    return Float(x)
  end
  def num(s, n)
    if (s == nil)
      return n
    end
    if(s.length > 5)
      return s[0..4]
    elsif(s.length < 5)
      temp = s
      while(temp.length < 5)
        temp = "0"+temp
      end
      return temp
    end
    return s
  end
  def col c
    if(c == nil || c == "")
      return "Unknown"
    end
    return c
  end
  def prog status
    if(status =~ /available/i)
      return nil
    elsif(status =~ /Earn.?a.?Bike/i || status =~ /E.?A.?B/i)
      return 1
    elsif(status =~ /Fix.?For.?Sale/i || status =~ /F.?F.?S/i)
      return 2
    elsif(status =~ /youth/i)
      return 3
    elsif(status =~ /scrap/i)
      return 4
    elsif(status =~ /build/i)
      return 5
    elsif(status =~ /as.?is/i)
      return 6
    elsif(status = /north/i)
      return 7
    end
    return nil
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
             
    i = 0
    numb = ""
    temp = ""
    while(i < worksheet.length - 1)
      i += 1
      temp = num(String(worksheet[i][0]), numb)
      if(temp == numb)
        next
      end
      numb = temp
      mod = String(worksheet[i][16])
      
      bm = nil
      brand = nil
      if(mod != nil && mod != "")
        bm = BikeModel.where(:name => mod).first
        #.find(rand(3)+1)
        if(bm != nil && bm != "")
          brand = bm.brand
        end
      end
      ws = froat(worksheet[i][8], true)
                                                
      b = Bike.create!(
        :program_id => prog(String(worksheet[i][19])),
        :color=>col(worksheet[i][14]),
        :seat_tube_height=>froat(worksheet[i][5], false),
        :top_tube_length=>froat(worksheet[i][7], false),
        :wheel_size => (ws) ? Integer(ws) : ws,
        :brand_id => (brand)? brand.id : brand,
        :bike_model_id => (bm) ? bm.id : bm,
        :quality => worksheet[i][17],
        :condition => worksheet[i][18],
        :number => numb)
      
     # current_assignment = Assignment.create!(:program_id => b.program_id,
      #                                          :bike_id => b.id,
       #                                         :active => true,
        #                                        :closed_at => nil)
    end
             
#    30.times do |n|
#      c = color[rand(color.size)]
#      val = rand(120-50)+50
#      sh = rand(25-14)+14
#      tl = sh+0.5
#
#      n_bike_info = rand(n_options)
#
#      progs = Program.count
#      prog_id = rand(progs+1)
#
#      available = rand(2)
#      if (available == 1)
#        prog_id = nil
#      end
#
#      #manufacturer = Faker::Company.name
#      #fake_model = Faker::Company.bs
#
#      #manufacturer = mfgr[n_bike_info]
#      #fake_model = model[n_bike_info]
#      bm = BikeModel.find(rand(3)+1)
#      brand = bm.brand
#
#      quality = rand(3)
#      if quality == 0
#        quality = "A"
#      elsif quality == 1
#        quality = "B"
#      elsif quality == 2
#        quality = "C"
#      end
#
#      condition = rand(3)
#      if condition == 0
#        condition = "A"
#      elsif condition == 1
#        condition = "B"
#      elsif condition == 2
#        condition = "C"
#      end
#
#      b = Bike.create!(
#                       :program_id => prog_id,
#                       :color=>c,
#                       :seat_tube_height=>sh, 
#                       :top_tube_length=>tl,
#                       :wheel_size => rand(700),
#                       :brand_id => brand.id,
#                       :bike_model_id => bm.id,
#                       :quality => quality,
#                       :condition => condition,
#                       :number => Bike.format_number(n+1001))
#      if rand(3)>0
#        b.reserve_hook
#      end
#    end
  end 
end
