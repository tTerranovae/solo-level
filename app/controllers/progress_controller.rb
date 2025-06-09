class ProgressController < ApplicationController
  before_action :authenticate_user!

  def index
    @progresses = current_user.progresses.includes(:topic)
  end

  def show
    topic_id = params[:id].to_i
    if topic_id <= 0
      redirect_to quizzes_path, alert: "Invalid topic selected."
      return
    end

    # First check if the topic exists
    topic = Topic.find_by(id: topic_id)
    if topic.nil?
      redirect_to quizzes_path, alert: "Topic not found."
      return
    end

    @progress = current_user.progresses.find_or_create_by!(topic: topic)
    @quiz_attempts = current_user.quiz_attempts.where(topic_id: topic_id).order(completed_at: :desc)
  end
end
