class HookReservationsController < ApplicationController

  expose(:hook) do
    unless params[:hook_id].blank?
      @hook ||= Hook.find_by_slug(params[:hook_id])
    end
  end

  # Post
  def create
    (redirect_to root_path and return) if fetch_failed?([bike, hook])
    
    reservation = HookReservation.new(:bike => bike, :hook => hook)
    if reservation.save
      flash[:success] = "Hook #{bike.hook.number} reserved successfully"
    else
      flash[:error] = "Could not reserve the hook."
    end
    
    redirect_to bike
  end

  # Delete
  def destroy
    if bike.vacate_hook
      flash[:success] = "Hook vacated"
    else
      flash[:error] = "Could not vacate hook"
    end

    redirect_to bike
  end

  # Get 
  def change
  end

  # Put
  def update
  end

end
