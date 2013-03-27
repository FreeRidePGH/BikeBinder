class HooksController < ApplicationController

  expose(:hook) do
    unless params[:id].blank?
      @hook ||= Hook.find_by_slug(params[:id])
    end
  end

  def show
    (redirect_to root_path and return) if fetch_failed?(hook)
  end

  def index
    redirect_to root_path and return
  end

end
