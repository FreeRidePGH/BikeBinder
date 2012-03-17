class ApplicationController < ActionController::Base
  protect_from_forgery

  def new_comment
    @commentable = params[:controller].singularize.classify.constantize.find(params[:id])
    
    @comment = Comment.build_from(@commentable, current_user, 
                                  params[:comment][:body])
    if @comment.save
      # Handle a successful save
      flash[:success] = "Thank you for your comment"
    else
      # Failed save
      flash[:error] = "Could not add your comment"
    end
    redirect_to @commentable
  end

end
