class Brand < ActiveRecord::Base
    attr_accessible :name
    has_many :bike_models
    has_many :bikes


    # Method to get all Brands for filters
    def self.all_brands
        Brand.all
    end

    def self.find_all_for_models(model_id)
        Brand.joins("JOIN bike_models ON brands.id = bike_models.brand_id").where("bike_models.id = ?",model_id)
    end
end
