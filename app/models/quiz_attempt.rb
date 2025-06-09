class QuizAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  has_many :question_attempts, dependent: :destroy
end
