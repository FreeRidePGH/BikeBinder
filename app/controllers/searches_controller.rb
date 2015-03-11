class SearchesController < ApplicationController

  # Method to search.
  # Queries in the form of a hook number search for a hook
  # Queries in the form of a bike number search for a bike
  def index

    authorize! :read, Bike
    authorize! :read, Hook

    query = BikeHookSearch.new(params).find
    @bike = query.bike
    @hook = query.hook

    redirect_to(@bike) and return unless @bike.nil?
    redirect_to(@hook) and return unless @hook.nil?    

    # Nothing found
    flash.now[:notice] = query.message
  end
  
end
