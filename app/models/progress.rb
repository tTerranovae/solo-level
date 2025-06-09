class Progress < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  has_many :quiz_attempts, -> { where(topic_id: topic_id) }, through: :user
end
