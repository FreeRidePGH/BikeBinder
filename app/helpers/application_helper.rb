module ApplicationHelper
  # trying out a dynamic assignment of a title for the header element
  def header_title
    title_key = "page_titles.#{controller_name.to_s}.#{action_name}"
    @title ||= I18n.translate(title_key)
    @title ||= "BikeBinder"
    @title 
  end

  # Converts the value to target_units and rounds the
  # result so it can be printed
  #
  def round_units(val, target_units='')
    if val.respond_to?(:convert_to)
      val = val.convert_to(target_units) unless target_units.blank?
      "%.2f #{val.units}" % val.scalar
    else
      "n/a"
    end
  end

  def render_flash_messages
    flash.each do |key, value|
      content_tag(:div, value, :class=>"alert alert-#{key}")
    end
  end
  
end
