class Question < ApplicationRecord
  belongs_to :topic, counter_cache: true

  # Enums
  enum :difficulty_level, {
    beginner: 1,
    intermediate: 2,
    advanced: 3,
    expert: 4,
    master: 5
  }

  enum :question_type, {
    multiple_choice: "multiple_choice",
    debugging: "debugging",
    project_based: "project_based"
  }

  # Validations
  validates :difficulty_level, presence: true, inclusion: { in: difficulty_levels.keys }
  validates :question_type, presence: true, inclusion: { in: question_types.keys }
  validates :metadata, presence: true
  validates :options, presence: true
  validates :text, presence: true
  validates :correct_answer, presence: true

  # Scopes
  scope :by_difficulty, ->(level) { where(difficulty_level: level) }
  scope :by_type, ->(type) { where(question_type: type) }
  scope :for_user_level, ->(user_level) {
    where("difficulty_level <= ?", [ user_level, 5 ].min)
  }

  # Methods
  def metadata
    self[:metadata] || {}
  end

  def metadata=(value)
    self[:metadata] = value.is_a?(Hash) ? value : {}
  end

  def difficulty_multiplier
    case difficulty_level
    when "beginner" then 1.0
    when "intermediate" then 1.5
    when "advanced" then 2.0
    when "expert" then 2.5
    when "master" then 3.0
    end
  end

  def calculate_points(base_points = 10)
    (base_points * difficulty_multiplier).round
  end
end
