class AdminController < ApplicationController
  before_action :authenticate_user!

  def index
    @topics = Topic.all
    @questions = Question.all
  end
end
