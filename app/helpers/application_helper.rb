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

  # Specifies a link class based on if the 
  # link is the current conroller & action
  def nav_bar_curr_class(args = {})
    if ((action_name.to_s == args[:action].to_s &&
        controller_name.to_s == args[:controller].to_s))
      "active"
    else
      nil
    end
  end # def nav_bar_curr_class

  def action_summary(event)
    return nil if event.blank?
    
    key, *args = event.action.split(",")
    params = Hash[args.combination(2).to_a].symbolize_keys
    action_text = I18n.translate("action.#{key}", params)
    date_text = Settings::Date.new(event.created_at).default_s
    user_text =  (event.user.uname if event.user) || I18n.translate("action_user_unknown")

    return I18n.translate("action_summary", 
                          :action => action_text, :date => date_text,:user => user_text)
  end
  
end
