class DeparturesController < ApplicationController

  expose(:departure) do
    if @dep.nil? && params[:id]
      id = params[:id]
      @dep ||= Departure.where(:id => id.to_i).first
    end
    @dep
  end

  expose(:destination) do
    # @dest ||= params[:destination] if params[:destination]
    if @dest.nil? && params[:destination_id]
      id = params[:destination_id]
      id = id.id if id.respond_to?(:id)
      
      @dest ||= Destination.
        where(:id => id.to_i).first unless id.nil?
    end
    @dest
  end

  # POST
  def create
    authorize! :create, Departure
    redirect_to root_path and return if fetch_failed?(bike)
    redirect_to bike and return unless verify_signatory
    
    if fetch_failed?([bike.assignment, destination], :on => :all)
      redirect_to bike_path(bike) and return 
    end

    # Check bike assignment-state before departing
    new_assignment = bike.available?

    departure = 
      Departure.build(:bike => bike, 
                      :value => params[:value].to_f, 
                      :destination => destination)
    if departure.save
      if new_assignment
        # Record the new assignment in the bike history
        hound_action bike, "assign_program,program,#{destination.label}"
        hound_action destination, "assign_bike,number,#{bike.number}"
      end
      hound_action bike, "depart"
      flash[:success] = I18n.translate('controller.departures.create.success', 
                                       :bike_number => bike.number,
                                       :method => departure.disposition.name)
    else
      flash[:error] = I18n.translate('controller.departures.create.fail', 
                                       :bike_number => bike.number)
    end
    
    redirect_to bike
  end # def create
  
  # DELETE
  def destroy
    authorize! :destroy, departure || Departure
    redirect_to root_path and return if fetch_failed?(departure)
    bike = departure.bike
    redirect_to(bike || root_path) and return unless verify_signatory

    if departure.destroy
      hound_action bike, "return"
      flash[:success] = I18n.translate('controller.departures.destroy.success')
    else
      flash[:error] = I18n.translate('controller.departures.destroy.fail')
    end

    redirect_to bike || root_path
  end

end
