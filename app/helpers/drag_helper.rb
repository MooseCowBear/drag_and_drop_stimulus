module DragHelper
  def partial_element(element)
    element.class.name.downcase.to_sym
  end
end
