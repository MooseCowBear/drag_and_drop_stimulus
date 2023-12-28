# Drag and drop Stimulus controller

A drag and drop Stimulus controller to reorder a collection of records. Controller sends a fetch request to the backend to update position in the database.

## Making a model draggable

To make a model drag-and-droppable, you only need to add a position column to the relevant table and `include Draggable` in the model.

The Draggable concern includes a method that adds a position to a new record.

```
# app/models/concerns/draggable

def new_with_position(params)
  curr_max = maximum(:position) || -1
  new(params.merge(position: curr_max + 1))
end
```

The create action of any controller for draggable models should use this method to ensure positions are unique within the model.

## Updating position after a drag and drop

The Stimulus Controller's fetch request includes a category, which is taken from the id of collection's parent element. On the backend, the Drag Controller identifies the model to update with

```
# app/controllers/drag_controller

def get_model(category)
  Object.const_get(category.singularize.capitalize)
end
```

So, for example, any of "task", "Task", "tasks", or "Tasks" would be an acceptable id for the parent container of a collection of `Task` instances, but "tasks_container" would not.

## Generalizing the draggable partial

In order to use a shared partial to add the drag-and-drop Stimulus controller, we pass not only the model instance but also the partial path associated with the model. This allows us to render the model instance's partial within the draggable partial with: 

```
# app/views/shared/_draggable.html.erb

<%= render element_partial, partial_element(element) => element %>
```

where `partial_element` returns the class name of the model instance as a lowercase symbol. 