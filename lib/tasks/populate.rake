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

task :populate_production_cold => :environment do
  # Create the db, load schema and seed
  Rake::Task['setup'].invoke
  Rake::Task['db:bike_mfg:index_repair'].invoke
  Rake::Task['db:populate_programs'].invoke
  Rake::Task['db:populate_destinations'].invoke
end

task :populate_production => :environment do
  Rake::Task['db:seed'].invoke
  Rake::Task['db:bike_mfg:index_repair'].invoke
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
    [{:name => "Scrap", :label =>"Scrap"},
     {:name => "As-is", :label => "As-is"},
     {:name => "Unknown", :label => "Unknown"}].each do |h|
      if Destination.where(:name => h[:name]).count == 0
        Destination.create!(h)
      else
        puts "Destination '#{h[:name]}' already exists."
      end
    end # each
  end

  desc "Load spreadsheet data into the database"
  task :populate_spreadsheet_data => :environment do
    require 'csv'
    require 'ostruct'
    data = CSV.read(File.join(File.dirname(__FILE__), 'InventoryDataSpreadsheet.csv'))

    header = data.delete_at(0)

    data.each do |row|
      record = OpenStruct.new
      (0..header.length-1).each do |i|
        val = row[i].strip unless row[i].nil?
        record.send("#{header[i].downcase}=", val) unless header[i].nil?
      end

      if record.id.nil?
        next
      end

      record.id = record.id.rjust(5, '0').to_s

      puts "Bike ID #{record.id}"
      bike = Bike.where(:number_record => record.id).first

      ['quality', 'condition'].each do |attr|
        unless record.send(attr).nil?
          record.send("#{attr}=", record.send(attr).downcase)
        end
      end
      
      # Create the record if it does not exist
      if bike.nil?
        bike_params = ActionController::Parameters.new({
          :bike_brand_name => record.brand,
          :bike_model_name => record.model,
          :seat_tube_height_units => "in",
          :top_tube_length_units => "in",
          :seat_tube_height => record.st,
          :top_tube_length => record.tt,
          :color => record.color.to_s.gsub(/'/, ''),
          :value => record.value,
          :wheel_size => record.wheel_size,
          :number_record => record.id,
          :quality => record.quality,
          :condition => record.condition
        })
        bike_form = BikeForm.new(Bike.new, bike_params.permit(:color, 
                                                              :seat_tube_height, 
                                                              :top_tube_length, 
                                                              :wheel_size,
                                                              :bike_model_id, 
                                                              :quality, 
                                                              :condition, 
                                                              :value, 
                                                              :number_record))
        if !bike_form.valid?
          raise "Bike creation errors. #{bike_form.errors.messages}"
        end
        bike_form.save
        bike = bike_form.bike
	puts "Bike #{bike.number} created"
      end # if bike.nil?

      if bike.nil?
        raise "Bike could not be found or created from record row"
      end

      # Assign bike if a program is specified
      program_name = case record.status
                     when "Youth" then "Youth"
                     when "Buildathon" then "Buildathon"
                     when "Fix for Sale" then "Fix for Sale"
                     when "Earn a Bike" then "Earn a Bike"
                     else nil
                     end # case record.status

      assignment = bike.assignment
      
      unless program_name.nil? || assignment
        program = Program.where(:name => program_name).first 
        if program.nil?
          raise "Program name not found"
        end
        assignment = Assignment.build(:bike => bike, :program => program)
        bike.assignment = assignment
        bike.save!
	puts "Bike #{bike.number} assigned"
      end

      # Depart bike when specified
      if record.dateout && !bike.departed?
        if assignment.nil?
          dest_name = case record.status
                      when "As-is" then "As-is"
                      when "Scrap" then "Scrap"
                      else nil
                    end
          destination = nil
          if dest_name
            destination = Destination.where(:name => dest_name).first 
            unless destination && destination.valid?
              raise "DateOut bike could not have a destination assigned"
            end
          end
        end # if assignment.nil?

        # verify that the bike is assigned or has a destination
        if bike.assignment.nil? && destination.nil?
          raise "DateOut bike must have a destination or assignment from status '#{record.status}'"
        end
        
        Departure.build(:bike => bike,
                        :value => record.value || bike.value || 0,
                        :destination => destination).save!
	puts "Bike #{bike.number} departed"
      end # Depart bike when specified

    end # data.each do |row|
  end # task :populate_spreadsheet_data => :environment

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

      vals = {
        :color=>c,
        :seat_tube_height=>Settings::LinearUnit.to_persistance_units(sh).scalar.to_f, 
        :top_tube_length=>Settings::LinearUnit.to_persistance_units(tl).scalar.to_f,
        :wheel_size => wheel,
        :bike_model_id => bike_model_id,
        :quality => quality,
        :condition => condition,
        :value => val,
        :number_record => BikeNumber.format_number(Bike.count+1)
      }
      params = ActionController::Parameters.new(vals)
      b = Bike.create!(params.permit(:color, :seat_tube_height, :top_tube_length, :wheel_size,
                                     :bike_model_id, :quality, :condition, :value, :number_record))

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
