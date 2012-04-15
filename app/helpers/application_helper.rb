module ApplicationHelper
  # trying out a dynamic assignment of a title for the header element
  def header_title

      new_title = "Bike Binder"


  end

  def render_flash_messages
    flash.each do |key, value|
      content_tag(:div, value, :class=>"alert alert-#{key}")
    end
  end
  
end
