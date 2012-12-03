class BikeModel < ActiveRecord::Base
    attr_accessible :name, :brand_id
    belongs_to :brand
    has_many :bikes
    
    validates_uniqueness_of :name, :allow_nil => true
end
