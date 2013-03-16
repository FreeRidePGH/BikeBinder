class DeparturesController < ApplicationController

  expose(:departure) do
    if @dep.nil? && params[:id]
      id = params[:id]
      @dep ||= Departure.where{id=my{id.to_i}}.first
    end
    @dep
  end

  expose(:destination) do
    @dest ||= params[:destination] if params[:destination]
    if @dest.nil?
      id = params[:destination_id]
      id = id.id if id.respond_to?(:id)
      
      @dest ||= Destination.
        where{id=my{id.to_i}}.first unless id.nil?
    end
    @dest
  end

  # GET
  def new
    
  end

  # POST
  def create
    (redirect_to root_path and return) if fetch_failed?(bike)
    
    if fetch_failed?([bike.assignment, destination], :on => :all)
      redirect_to new_bike_departure_path(bike) and return 
    end

    departure = 
      Departure.build(:bike => bike, 
                      :value => params[:value], 
                      :destination => destination)
    if departure.save
      flash[:success] = "Bike #{bike.number} assigned successfully departed as #{departure.method.name}"
    else
      flash[:error] = "Could not assign bike #{bike.number}."
    end
    
    redirect_to bike
  end # def create
  
  # DELETE
  def destroy
    (redirect_to root_path and return) if fetch_failed?(departure)
    bike = departure.bike
    
    if departure.destroy
      flash[:success] = "Bike returned"
    else
      flash[:error] = "Could not return the bike"
    end

    redirect_to bike || root_path
  end

end
