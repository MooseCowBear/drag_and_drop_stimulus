class DragController < ApplicationController
  def update
    model = get_model(drag_params[:category])
    model.update_positions(drag_params.except(:category))
    head :no_content
  end

  private

  def drag_params
    params.require(:drag).permit(:category, :id, :position)
  end

  def get_model(category)
    Object.const_get(category.singularize.capitalize)
  end
end
