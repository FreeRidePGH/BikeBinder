module ApplicationHelper
  # trying out a dynamic assignment of a title for the header element
  def header_title
    title_key = "page_titles.#{controller_name.to_s}.#{action_name}"
    @title ||= I18n.translate(title_key)
    @title ||= "BikeBinder"
    @title 
  end

  def render_flash_messages
    flash.each do |key, value|
      content_tag(:div, value, :class=>"alert alert-#{key}")
    end
  end
  
end
