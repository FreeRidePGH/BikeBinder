module BikesHelper

  def print_val(key, val)
    return nil if val.nil?
    case key
    when 'color'
      val.respond_to?(:name) ? val.name.capitalize : ColorNameI18n::Color.new(val).name.capitalize
    when 'seat_tube_height'
      "#{round_units(val, 'inch')} (#{round_units(val, 'cm')})"
    when 'top_tube_length'
      "#{round_units(val, 'inch')} (#{round_units(val, 'cm')})"
    when 'wheel_size'
      "#{val} mm"
    when 'bike_model_id'
      BikeModel.where(:id => val).name
    when 'quality'
      val
    when 'condition'
      val
    when 'value'
      "$#{val}"
    when 'number'
      val
    end
  end # def changeset_val

end # module BikesHelper
