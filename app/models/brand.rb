class Brand < ActiveRecord::Base
    attr_accessible :name
    has_many :bike_models
    has_many :bikes
    
    validates_uniqueness_of :name, :allow_nil => true


    # Method to get all Brands for filters
    def self.all_brands
        Brand.order("name ASC").all
    end

    def self.mobile_brands
        Brand.select("id,name").order(:name).all
    end

    def self.find_all_for_models(model_id)
        Brand.joins("JOIN bike_models ON brands.id = bike_models.brand_id").where("bike_models.id = ?",model_id)
    end
end
