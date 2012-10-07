class Brand < ActiveRecord::Base
    attr_accessible :name
    has_many :bike_models
    has_many :bikes
end
