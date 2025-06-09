class QuestionAttempt < ApplicationRecord
  belongs_to :quiz_attempt
  belongs_to :question
end
