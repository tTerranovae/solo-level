class QuizzesController < ApplicationController
  def index
    if current_user
      @topics = Topic.all
      render :index
    else
      render :landing
    end
  end

  def show
    authenticate_user!
    @topic = Topic.find(params[:id])
    @questions = @topic.questions
    @current_question_index = 0
  end

  def submit
    authenticate_user!
    
    begin
      ActiveRecord::Base.transaction do
        @topic = Topic.find(params[:id])
        @questions = @topic.questions
        
        # Validate that all questions were answered
        unanswered_questions = @questions.select { |q| params["question_#{q.id}"].blank? }
        if unanswered_questions.any?
          return redirect_to quiz_path(@topic), alert: "Please answer all questions before submitting."
        end

        # Calculate score
        score = 0
        total_questions = @questions.count

        @questions.each do |question|
          user_answer = params["question_#{question.id}"]
          score += 1 if user_answer == question.correct_answer
        end

        # Create a quiz attempt
        quiz_attempt = QuizAttempt.create!(
          user: current_user,
          topic: @topic,
          score: score,
          total_questions: total_questions,
          completed_at: Time.current
        )

        # Update or create progress
        progress = current_user.progresses.find_or_initialize_by(topic: @topic)
        progress.score = score
        progress.last_attempt = Time.current
        progress.save!

        # Update user stats
        update_user_stats(current_user, score, total_questions)

        redirect_to progress_path(progress), notice: "Quiz completed! Your score: #{score}/#{total_questions}"
      end
    rescue ActiveRecord::RecordInvalid => e
      redirect_to quiz_path(@topic), alert: "Error saving quiz results: #{e.message}"
    rescue StandardError => e
      redirect_to quiz_path(@topic), alert: "An unexpected error occurred. Please try again."
    end
  end

  private

  def update_user_stats(user, score, total_questions)
    # Award badges
    if score == total_questions
      current_badges = (user.badges || '').split(',').reject(&:blank?)
      current_badges << 'Perfect Score'
      user.badges = current_badges.uniq.join(',')
    end

    # Update XP and level
    xp_gained = (score.to_f / total_questions) * 100
    user.xp = (user.xp || 0) + xp_gained
    user.level = [(user.xp / 1000).floor + 1, 1].max # Ensure level is at least 1

    # Update streak
    user.streak = (user.streak || 0) + 1

    # Save all changes at once
    user.save!
  end
end
