require "test_helper"

class AdminControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @request.session[:user_id] = @user.id
  end

  test "should get index" do
    get :index
    assert_response :success
  end
end
