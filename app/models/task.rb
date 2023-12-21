class Task < ApplicationRecord
  validates :title, presence: true

  enum :category, { work: 0, personal: 1, school: 2 }
  enum :priority, { low: 0, medium: 1, high: 2 }

  scope :complete, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }
end
