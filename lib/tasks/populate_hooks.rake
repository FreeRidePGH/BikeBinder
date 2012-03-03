namespace :db do
  	desc "Fill database with initial Hooks"
	task :populate => :environment do	
	     Rake::Task['db:reset'].invoke
	     99.times do |n|
	     	       Hook.create!(:number=>(101+n))
		       Hook.create!(:number=>(201+n))
             end
	end

end
