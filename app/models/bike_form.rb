require 'bike_number'

# Form object for entering and editing bike data
class BikeForm

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  # include BikeMfg::ActsAsManufacturable

  # Bike Attributes
  attr_reader :color, :value, :wheel_size, :seat_tube_height, 
  :top_tube_length, :bike_model_id, :number, :quality, :condition

  # Bike object, model and brand attributes
  attr_reader :bike

  # BikeBrand and BikeModel attribues
  attr_reader :bike_brand_name, :bike_model_name, :bike_brand_id

  def form_method( action )
    m = {:edit => :put, :new => :post}
    m[action.to_sym]
  end

  def initialize(current_bike, params = {})
    params ||= {}
    @bike = current_bike || Bike.new
  
    # Populate data first from the supplied object
    parse_obj(bike)
    # Then populate from the optional params
    # Populating from params second
    # allows supplied params to override persisted
    # obj data
    parse_params(params)
  end

  def parse_obj(obj)
    bike_params_list.each do |p|
      set_val(p, obj.send(p).to_s)
    end
    bm = obj.model
    if bm
      set_val(:bike_model_name, bm.name)
      set_val(:bike_brand_name, bm.brand.name)
      set_val(:bike_brand_id, bm.brand.id)
    end
  end

  def parse_params(data)
    data.each do |key, val|
      val = nil if val.blank?
      set_val(key, val)
    end
  end

  # Validations
  validates_presence_of :number, :color
  validates :seat_tube_height,:top_tube_length,:value, :numericality => true, :allow_nil => true
  # validates_uniqueness_of :number, :allow_nil => true
  #validates :number, :format => { :with => Bike.number_pattern, :message => "Must be 5 digits exactly"}
  validates :number, :bike_number => true

  # Forms are never themselves persisted
  def persisted?
    false # || (bike.persisted? if bike)
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def self.bike_params_list
    [:color, :value, :wheel_size, :seat_tube_height, 
     :top_tube_length, :bike_model_id, 
     :number, :quality, :condition]
  end

  def self.form_params_list
    bike_params_list + [:bike_brand_id, :bike_brand_name, :bike_model_name]
  end

  private

  # bike brand and model cases
  #
  # Case model exists:
  #  then find create nothing
  #  then find model by id
  #
  # Case brand exists, but not the model
  #  then find brand by id
  #  then create model and assign to brand
  #
  # Case neither exist
  #  then create model and brand from given names
  #
  def bike_model_assignment!
    if BikeModel.find_by_id(bike_model_id)
      return bike_model_id
    end

    # find or create the brand
    brand = BikeBrand.find_by_id(bike_brand_id)
    brand ||= BikeBrand.new(bike_brand_params)
    brand.save if brand && brand.valid?
    
    # Create the bike model
    new_model = brand.models.new(bike_model_params) if brand && brand.persisted?
    new_model.save if new_model && new_model.valid?
    return new_model.id if new_model && new_model.persisted?
  end

  def bike_brand_params
    {:name=>bike_brand_name}
  end

  def bike_model_params
    {:name=>bike_model_name}
  end

  def bike_params_list
    self.class.bike_params_list
  end

  # Always create the bike record
  # Create bike model and brand records if they are new
  def persist!
    m_id = bike_model_assignment!

    bike.update_attributes(
                         :number => number,
                         :color => color, 
                         :value => value,
                         :wheel_size => wheel_size,
                         :seat_tube_height => seat_tube_height,
                         :top_tube_length => top_tube_length,
                         :bike_model_id => m_id
                     )
    bike.save!

  end

  def set_val(attrib, val)
    val = nil if val.blank?
    instance_variable_set("@#{attrib}", val)
  end

end
