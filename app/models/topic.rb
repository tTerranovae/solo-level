class Topic < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :progresses, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
end
