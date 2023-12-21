class Task < ApplicationRecord
  validates :title, presence: true
  validates :position, presence: true

  enum :category, { work: 0, personal: 1, school: 2 }
  enum :priority, { low: 0, medium: 1, high: 2 }

  scope :complete, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }
  scope :order_by_position, -> { order(position: :asc) }

  def self.new_with_position(task_params)
    new(task_params.merge(position: Task.maximum(:position) + 1))
  end
end
