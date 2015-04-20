class PagesController < ApplicationController
  before_filter :clear_flash
  skip_authorization_check
      
  def index
  end

  def show
    page = params[:id]
    render_path, @title = page_to_render(page)
    render render_path
  rescue ActionView::MissingTemplate => e
    Rails.logger.info "Sending 404 body for requested page #{e.path}"
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  private

  def page_to_render(page_param)
    path = "index"
    title = nil

    [I18n.translate('page_link'),
     I18n.translate('satic_page')].each do |list|
      if list.has_key?(page_param.to_sym)
        path = page_param.to_s
        title = list[page_param.to_sym].titleize
        break
      end
    end
    [path, title]
  end

end
