import { Controller } from "@hotwired/stimulus";

let resourceID;
let url;

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

    const newPosition = this.setNewPosition(dropTarget, draggedItem);

    const updates = this.getUpdates(draggedItem, newPosition);

    e.preventDefault();
  }

  findDropTarget(elem, parentId) {
    if (elem == null || elem.id == parentId) {
      return null;
    }
    return elem.closest(".draggable");
  }

  setNewPosition(target, item) {
    // returning position of target so we can use it to update the backend
    const relativePosition = target.compareDocumentPosition(item);
    if (relativePosition == Node.DOCUMENT_POSITION_FOLLOWING) {
      target.insertAdjacentElement("beforebegin", item);
    } else if (relativePosition == Node.DOCUMENT_POSITION_PRECEDING) {
      target.insertAdjacentElement("afterend", item);
    }
    return parseInt(target.dataset.position);
  }

  getUpdates(draggedItem, endPosition) {
    const startPosition = parseInt(draggedItem.dataset.position);
    const items = [...draggedItem.parentElement.children];
    const ids = [draggedItem.getAttribute("data-resource-id")];
    const newPositions = [endPosition];

    console.log(startPosition, endPosition);

    if (startPosition == endPosition) {
      return null;
    } else if (startPosition < endPosition) {
      this.getIdsAndPositions(
        items,
        startPosition + 1,
        endPosition,
        -1,
        ids,
        newPositions
      );
    } else {
      this.getIdsAndPositions(
        items,
        endPosition,
        startPosition - 1,
        1,
        ids,
        newPositions
      );
    }
    return { ids, newPositions };
  }

  between(lower, higher, val) {
    if (val >= lower && val <= higher) {
      return true;
    }
    return false;
  }

  getIdsAndPositions(
    items,
    lowerBound,
    upperBound,
    offset,
    idsArr,
    positionsArr
  ) {
    for (let i = 0; i < items.length; i++) {
      if (this.between(lowerBound, upperBound, items[i].dataset.position)) {
        idsArr.push(items[i].getAttribute("data-resource-id"));
        positionsArr.push(parseInt(items[i].dataset.position) + offset);
      }
    }
  }
}
