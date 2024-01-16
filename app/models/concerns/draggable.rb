module Draggable
  extend ActiveSupport::Concern

  included do
    validates :position, presence: true
    scope :order_by_position, -> { order(position: :asc) }
  end

  class_methods do
    def new_with_position(params)
      curr_max = maximum(:position) || -1
      new(params.merge(position: curr_max + 1))
    end

    def update_positions(id, end_position)
      dragged_record = find(id)
      start_position = dragged_record.position

      transaction do
        update_other_positions(start_position, end_position)
        dragged_record.update!(position: end_position)
      end
    end

    def update_other_positions(start_position, end_position)
      offset = offset(start_position, end_position) 
      range = positions(start_position, end_position)

      records_by_positions(range).each do |record|
        update_position(record, offset)
      end
    end

    def update_position(record, offset)
      record.update!(position: record.position + offset) 
    end

    def records_by_positions(range)
      where(position: range)
    end

    def offset(start_position, end_position)
      start_position < end_position ? -1 : 1
    end

    def positions(start_position, end_position)
      if start_position < end_position
        start_position + 1..end_position
      else 
        end_position..start_position - 1
      end
    end
  end
end