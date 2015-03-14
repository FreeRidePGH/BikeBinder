class PagesController < ApplicationController
  before_filter :clear_flash
  skip_authorization_check
      
  def index
  end

  def show
    render page = params[:id]
  rescue ActionView::MissingTemplate => e
    fail ActionController::RoutingError, "Page not found for '#{e.path}'"
  end
end
