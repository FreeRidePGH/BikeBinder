class SearchesController < ApplicationController

    # Method to search.
    # Length of 5 will go to bikes page
    # Length of 3 will go to hooks page
    def index
        @search = params[:search]
        if @search.size == 3
            @hook = Hook.find_by_label(@search)
            if @hook.nil? == false
                if @hook.bike.nil? == false
                    redirect_to(@hook.bike)
                else
                    redirect_to(@hook)
                end
                return
            end
        else
            @bikes = Bike.find_by_number(@search)
            if @bikes.nil? == false
                redirect_to(@bikes)
                return
            end
        end

        # Nothing found. Render browse page
        redirect_to :controller => 'bikes', :action => 'index', :search => @search
    end

    def browse
        @search = params[:search]
        puts @search
        # Get bikes with search param
        @bikes = Bike.simple_search(@search)
        @hooks = Hook.simple_search(@search)
    end

end
