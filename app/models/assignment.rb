class Assignment < ActiveRecord::Base
    attr_accessible :program_id,:bike_id,:active,:closed_at
    belongs_to :program
    belongs_to :bike

    def self.active_assignment(bike)
        Assignment.find_by_bike_id(bike).first
    end

    def depart
       self.active = false
       self.closed_at = Date.now
    end

    def self.create_assignment(prog_id,bike_id)
        a = Assignment.new
        a.active = true
        a.program_id = prog_id
        a.bike_id = bike_id
        a.save!
    end
    
end
