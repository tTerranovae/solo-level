class User < ApplicationRecord
  has_secure_password
  has_many :progresses
  has_many :topics, through: :progresses
  has_many :quiz_attempts

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || password.present? }

  after_initialize :set_defaults, if: :new_record?

  def metadata
    self[:metadata] || {}
  end

  def metadata=(value)
    self[:metadata] = value.is_a?(Hash) ? value : {}
  end

  def performance_tracker
    @performance_tracker ||= UserPerformanceTracker.new(self)
  end

  def track_question_performance(question, correct, time_taken)
    performance_tracker.track_question_performance(question, correct, time_taken)
  end

  def recommended_difficulty
    performance_tracker.calculate_recommended_difficulty
  end

  def recommended_question_types
    performance_tracker.recommended_question_types
  end

  def success_rate
    performance_tracker.calculate_success_rate
  end

  def average_response_time
    performance_tracker.calculate_average_time
  end

  private

  def set_defaults
    self.xp ||= 0
    self.level ||= 1
    self.streak ||= 0
  end
end
