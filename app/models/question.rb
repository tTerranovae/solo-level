class Question < ApplicationRecord
  belongs_to :topic
  
  def options
    self[:options] || []
  end

  def options=(value)
    self[:options] = value.is_a?(Array) ? value : []
  end
end
