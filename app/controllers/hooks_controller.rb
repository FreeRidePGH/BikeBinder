class HooksController < ApplicationController

  expose(:hook) do
    unless params[:id].blank?
      @hook ||= Hook.find_by_slug(params[:id])
    end
  end

  def show
  end

end
