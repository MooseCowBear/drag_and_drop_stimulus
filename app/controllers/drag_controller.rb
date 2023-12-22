class DragController < ApplicationController
  def update_position
    model = get_model(drag_params[:category])
    model.update(drag_params[:ids], convert_positions(drag_params[:positions]))
    head :no_content
  end

  private

  def drag_params
    params.require(:drag).permit(:category, :ids => [], :positions => []) 
  end

  def get_model(category)
    Object.const_get(category.singularize.capitalize)
  end

  def convert_positions(positions)
    positions.map{ |pos| { "position" => pos } }
  end
end
