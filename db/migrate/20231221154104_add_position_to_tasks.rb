class AddPositionToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :position, :integer, null: false
  end
end
