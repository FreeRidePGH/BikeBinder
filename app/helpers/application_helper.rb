module ApplicationHelper
  # Dynamic assignment of a title for the header element
  def header_title
    title_key = "page_titles.#{controller_name.to_s}.#{action_name}"
    optns = {:default => I18n.translate("page_titles.site")}
    if self.respond_to?(:title_data)
      optns.merge! title_data 
    end
    @title ||= I18n.translate(title_key, optns)
  end

  # Use different button text for forms
  # based on new vs. edit actions
  def submit_text
    case action_name.to_sym
    when :new, :create
      I18n.translate('commit_btn')[:new]
    when :edit, :update
      I18n.translate('commit_btn')[:edit]
    else
      I18n.translate('commit_btn')[:submit]      
    end
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

  # Creates a link and sets the class based on
  # if the link is the current conroller & action
  #
  # See the source for link_to for the basis on
  # how arguments are parsed and the block is used
  def nav_bar_item(*args, &block)
    optns = (block_given?) ? args.first : args[1] || {}
    
    controller = optns[:controller].to_s
    action = optns[:action].to_s
    current = (action_name.to_s == action &&
        controller_name.to_s == controller)
    curr_class = (current) ? "active" : nil

    content_tag :li, :class => curr_class do
      if block_given?
        link_to capture(&block), 
        {:controller => controller, :action => action}, {:class => curr_class}
      elsif name = args[0]
        link_to name, 
        {:controller => controller, :action => action}, {:class => curr_class}
      end
    end #content_tag :li
  end # nav_bar_item
  
end
