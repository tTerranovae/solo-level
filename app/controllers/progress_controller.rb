class ProgressController < ApplicationController
  before_action :authenticate_user!

  def index
    @progresses = current_user.progresses.includes(:topic)
  end

  def show
    @progress = current_user.progresses.includes(:topic).find(params[:id])
    @quiz_attempts = current_user.quiz_attempts.where(topic_id: @progress.topic_id).order(completed_at: :desc)
  end
end
