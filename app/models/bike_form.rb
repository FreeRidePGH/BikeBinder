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
  validate :form_validation

  def form_validation
    models = [bike]

    models.each do |m|
      unless m.valid?
        m.errors.each do |e_key, e_message|
          errors.add(e_key, e_message)
        end
      end
    end
  end # def form_validation

  # Forms are never themselves persisted
  def persisted?
    false
  end

  def save
    update_bike
    if valid?
      persist!
      true
    else
      false
    end
  end

  def self.bike_measurements_list
    [:seat_tube_height, :top_tube_length]
  end

  def bike_measurements_list
    self.class.bike_measurements_list
  end

  def self.bike_params_list
    bike_measurements_list +
    [:color, :value, :wheel_size, 
     :bike_model_id, :number,
     :quality, :condition]
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
    bike_measurements_list.each do |p|
      set_measurement(p, obj.send(p).to_s)
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
  
  
  # @params_list allowable params
  # @params_data data to assign
  # If data is not given for a parameter
  # in the list, then a value of nil is assigned.
  # This is necessary to make sure all parameters
  # are present.
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
    return nil if entered_val.blank?

    selected_units = self.send("#{attrib_name}_units")
    if selected_units.nil? || selected_units.strip.length == 0
      selected_units = Settings::LinearUnit.default_input.units      
    end

    given_unit = Unit.new(selected_units)
    begin
      val = Unit.new(entered_val)*given_unit
      Settings::LinearUnit.to_persistance_units(val).scalar.to_f
    rescue
      errors.add(attrib_name, I18n.translate('errors.invalid_measurement'))
      entered_val
    end
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

  def update_bike
    # update attributes
    bike.number = number
    bike.color = color
    bike.value = value
    bike.quality = quality
    bike.condition = condition
    bike.wheel_size = wheel_size
    bike.seat_tube_height = length_assignment(:seat_tube_height)
    bike.top_tube_length = length_assignment(:top_tube_length)
    bike.bike_model = bike_model_assignment
  end

  def persist!
    bike.save!
  end

  # set the form instance variable with the given attribute and value
  def set_val(attrib, val)
    val = (val.blank?) ? nil : val.to_s
    instance_variable_set("@#{attrib}", val)
  end
  
  # set the form instance variables for the given measurement
  # unit and set the associated units instance variable
  def set_measurement(attrib, val)
    val = (val.blank?) ? OpenStruct.new(:scalar => nil, :units => nil) : Unit.new(val)

    instance_variable_set("@#{attrib}", val.scalar)
    instance_variable_set("@#{attrib}_units", val.units)
  end

end
