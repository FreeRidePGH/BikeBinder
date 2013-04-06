class HooksController < ApplicationController

  expose(:hook) do
    unless params[:id].blank?
      @hook ||= Hook.find_by_slug(params[:id])
    end
  end

  def show
    authorize! :read, hook || Hook
    (redirect_to root_path and return) if fetch_failed?(hook)
  end

  def index
    authorize! :read, Hook
    redirect_to root_path and return
  end

end
