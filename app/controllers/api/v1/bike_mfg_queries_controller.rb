module Api
  module V1
    class BikeMfgQueriesController < ApplicationController
      before_filter :clear_flash
      skip_authorization_check
      unloadable
      include BikeMfg::Controllers::BikeMfgQueriesControllerMethods
    end
  end # v1
end #api
