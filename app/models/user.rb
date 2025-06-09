class User < ApplicationRecord
  has_many :progresses
  has_many :quiz_attempts
  has_many :topics, through: :progresses

  after_initialize :set_defaults, if: :new_record?

  private

  def set_defaults
    self.xp ||= 0
    self.level ||= 1
    self.streak ||= 0
  end
end
