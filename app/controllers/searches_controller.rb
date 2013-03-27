class SearchesController < ApplicationController

  expose :bikes do
    @bikes = Bike.simple_search(search_term)
  end

  expose :hooks do
    @hooks = Hook.simple_search(search_term)
  end
  
  # Method to search.
  # Queries in the form of a hook number search for a hook
  # Queries in the form of a bike number search for a bike
  def index
    if search_term =~ HookNumber.anchored_pattern
      @hook = Hook.find_by_slug(search_term)
      @bike = @hook.bike if @hook
    elsif search_term =~ BikeNumber.anchored_pattern
      @bike = Bike.find_by_slug(search_term)
    end

    redirect_to(@bike) and return unless @bike.nil?
    redirect_to(@hook) and return unless @hook.nil?    
    
    # Nothing found. Render browse page
    # render :browse

    flash[:error] = I18n.translate('controller.searches.index.fail', :term => search_term)
    redirect_to :controller => 'bikes', :action => 'index', :q => search_term
  end
  
end
