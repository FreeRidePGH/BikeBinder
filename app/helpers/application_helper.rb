module ApplicationHelper
  # trying out a dynamic assignment of a title for the header element
  def header_title
    if  ! @title.nil?
      new_title = @title
    else 
      new_title = "Bike Binder"
    end
    new_title
  end

  def render_flash_messages
    flash.each do |key, value|
      content_tag(:div, value, :class=>"alert alert-#{key}")
    end
  end
  
end
