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

    this.setNewPosition(dropTarget, draggedItem);

    const updates = this.getUpdates(draggedItem, dropTarget);
    console.log("updates to send", updates);

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
    if (relativePosition == Node.DOCUMENT_POSITION_FOLLOWING) {
      target.insertAdjacentElement("beforebegin", item);
    } else if (relativePosition == Node.DOCUMENT_POSITION_PRECEDING) {
      target.insertAdjacentElement("afterend", item);
    }
  }

  getUpdates(draggedItem, dropTarget) {
    console.log(draggedItem, dropTarget);
    const endPosition = parseInt(dropTarget.dataset.position);
    const startPosition = parseInt(draggedItem.dataset.position);
    const items = [...draggedItem.parentElement.children];
    let updates = null;

    console.log(startPosition, endPosition);

    if (startPosition == endPosition) {
      return updates;
    } else if (startPosition < endPosition) {
      updates = this.getIdsAndPositions(
        items,
        startPosition + 1,
        endPosition,
        -1
      );
    } else {
      updates = this.getIdsAndPositions(
        items,
        endPosition,
        startPosition - 1,
        1
      );
    }

    updates.ids.push(resourceID);
    updates.positions.push(endPosition);

    return updates;
  }

  between(lower, higher, val) {
    if (val >= lower && val <= higher) {
      return true;
    }
    return false;
  }

  getIdsAndPositions(items, lowerBound, upperBound, offset) {
    const res = items.reduce(
      (filtered, item) => {
        if (
          this.between(lowerBound, upperBound, parseInt(item.dataset.position))
        ) {
          filtered.ids.push(item.getAttribute("data-resource-id"));
          filtered.positions.push(parseInt(item.dataset.position) + offset);
        }
        return filtered;
      },
      { ids: [], positions: [] }
    );
    console.log(res);
    return res;
  }
}
