class Brand < ActiveRecord::Base
    attr_accessible :name
    has_many :bike_models
    has_many :bikes


    # Method to get all Brands for filters
    def self.all_brands
        Brand.all
    end
end
