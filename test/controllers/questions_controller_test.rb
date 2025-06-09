require "test_helper"

class QuestionsControllerTest < ActionController::TestCase
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

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should show question" do
    get :show, params: { id: @question }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @question }
    assert_response :success
  end

  test "should destroy question" do
    # Clean up related question_attempts
    QuestionAttempt.where(question: @question).delete_all
    assert_difference("Question.count", -1) do
      delete :destroy, params: { id: @question }
    end
    assert_redirected_to questions_path
  end
end
