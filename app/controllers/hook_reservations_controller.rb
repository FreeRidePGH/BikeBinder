class HookReservationsController < ApplicationController

  expose(:hook) do
    unless params[:hook_id].blank?
      @hook ||= Hook.find_by_slug(params[:hook_id])
    end
    @hook
  end
  
  expose(:reservation) do
    unless params[:id].blank?
      @reservation ||= HookReservation.where(:id => params[:id].to_i).first
    end
    @reservation
  end

  # Post
  def create
    redirect_to root_path and return if fetch_failed? bike
    
    reservation = HookReservation.new(:bike => bike, :hook => hook)
    if reservation.save
      flash[:success] = I18n.translate('controller.hook_reservations.create.success', :hook_number => bike.hook.number)
    else
      flash[:error] = I18n.translate('controller.hook_reservations.create.fail')
    end
    
    redirect_to bike
  end

  # Delete
  def destroy
    bike = reservation.bike if reservation
    redirect_to root_path and return if fetch_failed?([reservation, bike])
    
    if reservation.destroy
      flash[:success] = I18n.translate('controller.hook_reservations.destroy.success')
    else
      flash[:error] = I18n.translate('controller.hook_reservations.destroy.fail')
    end

    redirect_to bike.reload
  end

  # Get 
  def new
  end

  # Put
  def update
    bike = reservation.bike if reservation
    redirect_to root_path and return if fetch_failed?([reservation, bike])
    
    call_events(reservation, [:bike, :hook], params)
    if reservation.save
      flash[:success] = I18n.translate('controller.hook_reservations.update.success')
    else
      flash[:error] = I18n.translate('controller.hook_reservations.update.fail')
    end
    
    redirect_to bike
  end

  private
  
  # For the given object that implements a state machine,
  # call the given events if they apply to the states listed
  # 
  def call_events(obj, states, events)
    states.each do |state|
      event_action = events["#{state}_event".to_sym]
      if event_action.present?
        event = "#{event_action}_#{state}"
        event_test = "can_#{event}?"
        if obj.respond_to?(event_test) && obj.send(event_test)
            obj.send("#{event}")
        end
      end
    end
  end

end
