import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="drag-and-drop"
export default class extends Controller {
  connect() {}

  dragStart(e) {
    e.dataTransfer.setData(
      "text/plain",
      e.target.getAttribute("data-resource-id")
    );
    e.dataTransfer.effectAllowed = "move";
  }

  dragEnter(e) {
    e.preventDefault();
  }

  dragOver(e) {
    e.preventDefault();
    return false;
  }

  dragEnd(e) {
    e.preventDefault();
  }

  drop(e) {
    const dropTarget = this.findDropTarget(e.target);
    const itemId = e.dataTransfer.getData("text");
    const draggedItem = document.querySelector(
      `[data-resource-id="${itemId}"]`
    );

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
        body: JSON.stringify(this.getUpdate(draggedItem, itemId)),
      });
    }
    e.preventDefault();
  }

  findDropTarget(elem) {
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

  getUpdate(draggedItem, id) {
    return {
      category: draggedItem.parentElement.id,
      position: [...draggedItem.parentElement.children].indexOf(draggedItem),
      id: id,
    };
  }
}
