class HooksController < ApplicationController

 def show
    @hook = Hook.find(params[:id])
 end

end
