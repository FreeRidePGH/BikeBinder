require 'bike_number'

# Form object for entering and editing bike data
class BikeForm

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  # include BikeMfg::ActsAsManufacturable

  # Bike Attributes
  attr_reader :color, :value, :wheel_size, 
  :seat_tube_height, :seat_tube_height_units, 
  :top_tube_length, :top_tube_length_units,
  :bike_model_id, :number, :quality, :condition

  # Bike object
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
    # Populating from params second allows
    # the supplied params to override
    # persisted obj data
    parse_params(form_params_list, params) unless params.empty?
  end

  # Validations
  validates_presence_of :number, :color
  validates :seat_tube_height,:top_tube_length,:value, :numericality => true, :allow_nil => true
  # validates_uniqueness_of :number, :allow_nil => true
  #validates :number, :format => { :with => Bike.number_pattern, :message => "Must be 5 digits exactly"}
  validates :number, :bike_number => true

  # Forms are never themselves persisted
  def persisted?
    false
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

  def bike_params_list
    self.class.bike_params_list
  end

  def self.form_params_list
    bike_params_list + [:bike_brand_id, :bike_brand_name, :bike_model_name,
                       :seat_tube_height_units, :top_tube_length_units]
  end
  
  def form_params_list
    self.class.form_params_list
  end

  private

  def parse_obj(obj)
    bike_params_list.each do |p|
      set_val(p, obj.send(p).to_s)
    end
    bm = obj.model
    if bm
      set_val(:bike_model_id, bm.id)
      set_val(:bike_model_name, bm.name)
      
      # Must check that a brand is assigned, since it
      # may be unknown (nil)
      unless bm.brand.nil?
        set_val(:bike_brand_name, bm.brand.name)
        set_val(:bike_brand_id, bm.brand.id)
      end
    end
  end
  
  def parse_params(params_list, params_data)
    params_list.each do |key|
      set_val(key, params_data[key])
    end
  end

  # Get the bike model assignment
  # based on the BikeModelFactory for 
  # the given bike brand and model cases
  #
  # Cache the assignment for consistency between calls
  def bike_model_assignment
    if @built_bike_model.nil?
      factory = BikeModelFactory.new(model_factory_params)
      @built_bike_model = factory.model unless factory.nil?
    end
    @built_bike_model
  end

  # Assign the value of the given attribute
  # using the correct unit conversion
  def length_assignment(attrib_name)
    entered_val = self.send(attrib_name)
    selected_units = self.send("#{attrib_name}_units")

    given_unit = Unit.new(selected_units)
    val = Unit.new(entered_val)*given_unit
    Settings::LinearUnit.to_persistance_units(val).scalar.to_f
  end

  def model_factory_params
    {
      :model_id => bike_model_id,
      :model_name => bike_model_name,
      :brand_id => bike_brand_id,
      :brand_name => bike_brand_name,
      :brand_scope => BikeBrand,
      :model_scope => BikeModel,
      :param_prefix => :bike
    }
  end

  def persist!

    # update attributes
    bike.number = number
    bike.color = color
    bike.value = value
    bike.wheel_size = wheel_size
    bike.seat_tube_height = length_assignment(:seat_tube_height)
    bike.top_tube_length = length_assignment(:top_tube_length)
    bike.bike_model = bike_model_assignment

    bike.save!
  end

  def set_val(attrib, val)
    val = (val.blank?) ? nil : val.to_s
    instance_variable_set("@#{attrib}", val)
  end

end
