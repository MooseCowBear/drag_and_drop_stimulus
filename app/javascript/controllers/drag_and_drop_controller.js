import { Controller } from "@hotwired/stimulus";

let resourceID;

// Connects to data-controller="drag-and-drop"
export default class extends Controller {
  connect() {}

  dragStart(e) {
    resourceID = e.target.getAttribute("data-resource-id");
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
  }

  drop(e) {
    const dropTarget = this.findDropTarget(e.target);
    const draggedItem = document.querySelector(
      `[data-resource-id="${resourceID}"]`
    );

    if (draggedItem === null || dropTarget === null) {
      return true;
    }

    this.setNewPosition(dropTarget, draggedItem);

    if (dropTarget != draggedItem) {
      const token = document.querySelector('meta[name="csrf-token"]').content;
      const url = "/drag";

      fetch(url, {
        method: "POST",
        headers: {
          "X-CSRF-Token": token,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(this.getUpdate(draggedItem, dropTarget)),
      });
    }
    e.preventDefault();
  }

  findDropTarget(elem) {
    if (elem == null) {
      return null;
    }
    return elem.closest('[draggable="true"]');
  }

  setNewPosition(target, item) {
    const relativePosition = target.compareDocumentPosition(item);
    if (relativePosition == Node.DOCUMENT_POSITION_FOLLOWING) {
      target.insertAdjacentElement("beforebegin", item);
    } else if (relativePosition == Node.DOCUMENT_POSITION_PRECEDING) {
      target.insertAdjacentElement("afterend", item);
    }
  }

  getUpdate(draggedItem, dropTarget) {
    return {
      category: draggedItem.getAttribute("data-parent"),
      position: parseInt(dropTarget.dataset.position),
      id: resourceID,
    };
  }
}
