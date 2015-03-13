class PagesController < ApplicationController
  before_filter :clear_flash
  skip_authorization_check
      
  def index
  end

  def show
    render params[:id]
  end
end
