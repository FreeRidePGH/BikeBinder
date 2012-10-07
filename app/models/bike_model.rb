class BikeModel < ActiveRecord::Base
    attr_accessible :name, :brand_id
    belongs_to :brand
    has_many :bikes
end
