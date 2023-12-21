import { Controller } from "@hotwired/stimulus";

let resourceID;
let url;
let newPosition;

// Connects to data-controller="drag-and-drop"
export default class extends Controller {
  connect() {
    console.log("controller is connected");
  }

  dragStart(e) {
    resourceID = e.target.getAttribute("data-resource-id");
    url = e.target.getAttribute("data-url");
    e.dataTransfer.effectAllowed = "move";
  }

  dragEnter(e) {
    e.preventDefault();
  }

  dragOver(e) {
    e.preventDefault();
  }

  dragEnd(e) {
    e.preventDefault();

    // TODO: finish this
  }

  drop(e) {
    const dropTarget = this.findDropTarget(
      e.target,
      e.target.getAttribute("data-parent")
    ); 
    const draggedItem = document.querySelector(
      `[data-resource-id="${resourceID}"]`
    );

    if (draggedItem === null || dropTarget === null) {
      return true;
    }

    this.setNewPosition(dropTarget, draggedItem);
    // find the place that the item ended up
    newPosition = [...this.element.parentElement.children].indexOf(draggedItem); 

    e.preventDefault();
  }

  findDropTarget(elem, parentId) {
    if (elem == null || elem.id == parentId) {
      return null;
    }
    return elem.closest(".draggable");
  }

  setNewPosition(target, item) {
    const relativePosition = target.compareDocumentPosition(item);
    console.log("relative position", relativePosition);
    if (
      relativePosition &&
      relativePosition == Node.DOCUMENT_POSITION_FOLLOWING
    ) {
      target.insertAdjacentElement("beforebegin", item);
    } else if (
      relativePosition &&
      relativePosition == Node.DOCUMENT_POSITION_PRECEDING
    ) {
      target.insertAdjacentElement("afterend", item);
    }
  }
}
