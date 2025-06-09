require "test_helper"

class TopicsControllerTest < ActionController::TestCase
  setup do
    @topic = topics(:one)
    @user = users(:one)
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

  test "should create topic" do
    assert_difference("Topic.count") do
      post :create, params: { topic: { name: "New Topic", description: "New Description", order: 1 } }
    end

    assert_redirected_to topic_path(Topic.last)
  end

  test "should show topic" do
    get :show, params: { id: @topic }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @topic }
    assert_response :success
  end

  test "should update topic" do
    patch :update, params: { id: @topic, topic: { name: "Updated Topic", description: "Updated Description", order: 2 } }
    assert_redirected_to topic_path(@topic)
  end

  test "should destroy topic" do
    # First delete all related records
    QuestionAttempt.where(question: @topic.questions).delete_all
    QuizAttempt.where(topic: @topic).delete_all
    @topic.questions.destroy_all

    assert_difference("Topic.count", -1) do
      delete :destroy, params: { id: @topic }
    end

    assert_redirected_to topics_path
  end
end
