class QuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [ :show, :submit, :results ]
  before_action :set_quiz, only: [ :show, :submit, :results ]

  def index
    @topics = Topic.all
  end

  def show
    @questions = select_questions_for_quiz
    @current_question_index = 0
    session[:quiz_start_time] = Time.current.to_f
    # Store the question IDs in the session for submission
    session[:quiz_question_ids] = @questions.map(&:id)
  end

  def submit
    @progress = current_user.progresses.find_or_create_by(topic: @topic)

    # Permit and get the answers from the form
    permitted_params = params.permit(answers: {}, start_times: {}, end_times: {}, time_spent: {})
    answers = permitted_params[:answers].to_h
    start_times = permitted_params[:start_times].to_h
    end_times = permitted_params[:end_times].to_h
    time_spent = permitted_params[:time_spent].to_h

    # Calculate score
    score = 0
    total_questions = answers.size

    # Create quiz attempt
    quiz_attempt = current_user.quiz_attempts.create!(
      topic: @topic,
      score: 0,
      total_questions: total_questions,
      completed_at: Time.current
    )

    # Process each question
    answers.each do |question_id, user_answer|
      question = Question.find(question_id)
      is_correct = user_answer == question.correct_answer
      score += 1 if is_correct

      # Use the time_spent parameter directly
      question_time = time_spent[question_id].to_i

      # Create question attempt
      quiz_attempt.question_attempts.create!(
        question: question,
        user_answer: user_answer,
        is_correct: is_correct,
        time_spent: question_time
      )
    end

    # Update quiz attempt with final score
    quiz_attempt.update!(score: score)

    # Update user's progress if they got a perfect score
    if score == total_questions
      @progress.update!(score: [ @progress.score.to_i, score ].max)
    end

    # Return results directly
    render json: {
      success: true,
      results: {
        score: score,
        total_questions: total_questions,
        topic_name: @topic.name,
        topic_id: @topic.id,
        user_level: current_user.level
      }
    }
  end

  def results
    @results = session[:quiz_results]

    # Always try to get the latest quiz attempt
    @latest_attempt = current_user.quiz_attempts
                                 .where(topic_id: @topic.id)
                                 .order(completed_at: :desc)
                                 .first

    if @results.nil? && @latest_attempt.nil?
      redirect_to quiz_path(@topic), alert: "No results available. Please complete the quiz first."
      return
    end

    # If we have session results, use those
    if @results
      @score = @results[:score]
      @total_questions = @results[:total_questions]
      @correct_answers = @results[:correct_answers]
      @incorrect_answers = @results[:incorrect_answers]
      @time_taken = @results[:time_taken]
    # Otherwise use the latest attempt
    elsif @latest_attempt
      @score = @latest_attempt.score
      @total_questions = @latest_attempt.total_questions
      @correct_answers = @score  # Score represents correct answers
      @incorrect_answers = @total_questions - @score
      @time_taken = 0  # We don't store time taken in the database
    end

    # Don't clear the session data until after the view is rendered
    response.headers["X-Session-Clear"] = "true" if @results
  end

  def after_action
    super
    # Clear the session data after the response is sent
    if response.headers["X-Session-Clear"] == "true"
      session.delete(:quiz_results)
      response.headers.delete("X-Session-Clear")
    end
  end

  private

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def set_quiz
    @quiz = @topic
  end

  def quiz_params
    params.permit(:id, :authenticity_token, answers: {}, start_times: {}, end_times: {}, time_spent: {})
  end

  def select_questions_for_quiz
    # Get user's recommended difficulty and question types
    difficulty = current_user.recommended_difficulty
    question_types = current_user.recommended_question_types

    # Convert difficulty string to integer
    difficulty_level = case difficulty
    when "beginner" then 1
    when "intermediate" then 2
    when "advanced" then 3
    when "expert" then 4
    when "master" then 5
    else 1
    end

    # First try to get questions with the exact criteria
    questions = @topic.questions
      .for_user_level(current_user.level)
      .by_difficulty(difficulty_level)
      .where(question_type: question_types)
      .order("RANDOM()")
      .limit(5)

    # If we don't have enough questions, try to get any questions for this topic
    if questions.count < 5
      remaining_count = 5 - questions.count
      additional_questions = @topic.questions
        .where.not(id: questions.pluck(:id))
        .order("RANDOM()")
        .limit(remaining_count)

      questions = questions + additional_questions
    end

    # If we still don't have enough questions, return what we have
    questions
  end

  def update_user_progress(score, total_questions)
    progress = current_user.progresses.find_or_initialize_by(topic: @topic)

    # Update progress with the new score if it's higher than the current score
    if progress.score.nil? || score > progress.score
      progress.score = score
    end

    # Update last attempt time
    progress.last_attempt = Time.current

    # Save the progress
    progress.save!
  end
end
