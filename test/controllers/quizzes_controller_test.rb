require "test_helper"

class QuizzesControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @topic = topics(:one)
    @question = questions(:one)
    @request.session[:user_id] = @user.id
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, params: { id: @topic }
    assert_response :success
  end
end
