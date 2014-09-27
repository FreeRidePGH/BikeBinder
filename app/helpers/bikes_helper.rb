module BikesHelper

  def print_val(key, val)
    return nil if val.blank?
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
      BikeModel.where(:id => val.to_i ).first.to_s
    when 'quality'
      val.capitalize
    when 'condition'
      val.capitalize
    when 'value'
      sprintf("$%.2f", val)
    when 'number_record'
      val
    end
  end # def changeset_val

  def filter_link_class(key)
    key_default = params[:status].blank? && key.to_s == 'all'
    key_active = key.to_s == params[:status]
    return (key_default || key_active) ? 'active' : 'option'
  end

end # module BikesHelper
