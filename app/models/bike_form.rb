# Form object for entering and editing bike data
class BikeForm
  
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  
  # Bike Attributes
  attr_accessor :color, :value, :wheel_size, :seat_tube_height, 
  :top_tube_length, :bike_model_id, :number, :quality, :condition

  # Bike model and brand attributes
  attr_accessor :bike_brand_name, :bike_model_name, :bike_brand_id

  def initialize(vals)
    vals ||= {}
    vals.each do |key, val|
      set_val(key, val)
    end
  end

  # Validations
  validates_presence_of :number, :color
  validates :seat_tube_height,:top_tube_length,:value, :numericality => true, :allow_nil => true
  # validates_uniqueness_of :number, :allow_nil => true
  validates :number, :format => { :with => Bike.number_pattern, :message => "Must be 5 digits exactly"}


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
    return new_model.id if new_model && new_model.persited?
  end

  def bike_brand_params
    {:name=>bike_brand_name}
  end

  def bike_model_params
    {:name=>bike_model_name}
  end

  # Always create the bike record
  # Create bike model and brand records if they are new
  def persist!
    m_id = bike_model_assignment!
    @bike = Bike.create!(
                         :number => number,
                         :color => color, 
                         :value => value,
                         :wheel_size => wheel_size,
                         :seat_tube_height => seat_tube_height,
                         :top_tube_length => top_tube_length,
                         :bike_model_id => m_id
                     )
  end

  def set_val(attrib, val)
    val = nil if val.blank?
    instance_variable_set("@#{attrib}", val)
  end

end
