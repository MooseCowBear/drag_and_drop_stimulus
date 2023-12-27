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

    def update_positions(strong_params)
      dragged_record = find(strong_params[:id])
      end_position = strong_params[:position]
      start_position = dragged_record.position

      transaction do
        find_and_update_other_positions(start_position, end_position)
        dragged_record.update(strong_params.except(:category))
      end
    end

    def find_and_update_other_positions(start_position, end_position)
      offset = offset(start_position, end_position) 

      range = positions(start_position, end_position)
      pp range

      records_by_positions(range).each do |record|
        update_position(record, offset)
      end
    end

    def update_position(record, offset)
      update(record.id, position: record.position + offset) 
    end

    def records_by_positions(range)
      where(position: range)
    end

    def offset(start_position, end_position)
      start_position < end_position ? -1 : 1
    end

    def positions(start_position, end_position)
      if start_position < end_position
        (start_position + 1..end_position)
      else 
        (end_position..start_position - 1)
      end
    end
  end
end