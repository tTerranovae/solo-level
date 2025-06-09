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

  test "should create question" do
    assert_difference("Question.count") do
      post :create, params: {
        question: {
          topic_id: @topic.id,
          text: "Test question?",
          qtype: "multiple_choice",
          options: [ "A", "B" ],
          correct_answer: "A",
          explanation: "Test explanation",
          difficulty_level: 1,
          question_type: "multiple_choice",
          metadata: {}
        }
      }
    end
    assert_redirected_to question_path(Question.last)
  end

  test "should show question" do
    get :show, params: { id: @question }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @question }
    assert_response :success
  end

  test "should update question" do
    patch :update, params: {
      id: @question,
      question: {
        text: "Updated question?",
        qtype: "multiple_choice",
        options: [ "A", "B" ],
        correct_answer: "B",
        explanation: "Updated explanation",
        difficulty_level: 1,
        question_type: "multiple_choice",
        metadata: {}
      }
    }
    assert_redirected_to question_path(@question)
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
