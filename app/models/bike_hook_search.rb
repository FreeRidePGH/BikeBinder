class BikeHookSearch

  attr_reader :message, :bike, :hook

  attr_reader :search_term, :bike_number, :hook_number

  def self.params_allowed
    %w(q bike_number hook_number bike_color bike_model bike_brand)
  end

  def initialize(params)
    parse_params(params)
    @message = nil
  end

  def find
    if blank_search?
      @message = I18n.translate('controller.searches.index.blank_search', :term => search_term)
    elsif term_for_simple_search?
      simple_search
      if @bike.nil?
        @message = I18n.translate('controller.searches.index.fail', :term => search_term)
      end
    else
      advanced_search
      @message = advanced_search_fail_message
    end
    return self
  end

  private

  def missing_param?(p)
    (p.nil? || p.empty?)
  end

  def advanced_search_fail_message
    advanced_params = {:bike_number_label=>bike_number, :hook_number_label=>hook_number}
    failed_terms = ""

    advanced_params.each do |key, param|
      if !missing_param?(param)
        failed_terms += I18n.translate('advanced_search.'+key.to_s)+" "+param+", "
      end
    end

    # remove trailing comma
    I18n.translate('controller.searches.index.fail', :term => failed_terms[0..-3])
  end

  def advanced_search
    if bike_number =~ BikeNumber.anchored_pattern
      bike_number_search(bike_number)
    elsif hook_number =~ HookNumber.anchored_pattern
      hook_number_search(hook_number)
    end
  end

  def simple_search
    if search_term =~ HookNumber.anchored_pattern
      hook_number_search(search_term)
    elsif search_term =~ BikeNumber.anchored_pattern
      bike_number_search(search_term)
    end
  end

  def bike_number_search(term)
    @bike = Bike.find_by_slug(term)
  end

  def hook_number_search(term)
    @hook = Hook.find_by_slug(term)
    @bike = @hook.bike if @hook
  end

  def blank_search?
    [search_term,
    bike_number,
    hook_number].each do |a|
      if !missing_param?(a)
        return false
      end
    end
    return true
  end

  def term_for_simple_search?
    !missing_param?(search_term)
  end

  def parse_params(params)
    @search_term = get_term(params, :q)

    @bike_number = get_term(params, :bike_number)
    @hook_number = get_term(params, :hook_number)

    @bike_color = get_term(params, :bike_color)
    @bike_model = get_term(params, :bike_model)
    @bike_brand = get_term(params, :bike_brand)
  end

  def get_term(params, key)
    params[key].to_s.strip
  end
end # class BikeSearch
