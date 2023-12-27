class Task < ApplicationRecord
  include Draggable

  validates :title, presence: true
  validates :position, presence: true #should go in concern

  enum :category, { work: 0, personal: 1, school: 2 }
  enum :priority, { low: 0, medium: 1, high: 2 }

  scope :complete, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }
  scope :order_by_position, -> { order(position: :asc) } #should go in concern
end
