class PagesController < ApplicationController
  before_filter :clear_flash
  skip_authorization_check
      
  def index
  end

  def show
    page = params[:id]
    @title = I18n.translate('page_link.'+page).titleize
    render page
  rescue ActionView::MissingTemplate => e
    Rails.logger.info "Sending 404 body for requested page #{e.path}"
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end
end
