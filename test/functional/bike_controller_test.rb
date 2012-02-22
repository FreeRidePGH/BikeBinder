require 'test_helper'

class BikeControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

end
