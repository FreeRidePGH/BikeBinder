class SearchesController < ApplicationController

  # Method to search.
  # Queries in the form of a hook number search for a hook
  # Queries in the form of a bike number search for a bike
  def index

    authorize! :read, Bike
    authorize! :read, Hook

    @search_number = (search_term.nil? || search_term.empty?) ? params[:num].to_s.strip : search_term
    @search_keywords = params[:keywords].to_s.strip

    if @search_number =~ HookNumber.anchored_pattern
      @hook = Hook.find_by_slug(@search_number)
      @bike = @hook.bike if @hook
    elsif @search_number =~ BikeNumber.anchored_pattern
      @bike = Bike.find_by_slug(@search_number)
    end

    redirect_to(@bike) and return unless @bike.nil?
    redirect_to(@hook) and return unless @hook.nil?    
    
    # Nothing found
    flash[:error] = I18n.translate('controller.searches.index.fail', :term => (@search_number +' '+ @search_keywords).strip)
  end
  
end
