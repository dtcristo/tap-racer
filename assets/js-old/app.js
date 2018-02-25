import "phoenix_html"

// import socket from "./socket"
import loadView from "./views/loader"

function handleDOMContentLoaded() {
  // Get the current view name
  const viewName = $("body").data("jsViewName")

  // Load view class and mount it
  const ViewClass = loadView(viewName)
  const view = new ViewClass()
  view.mount()
  window.currentView = view
}

function handleDocumentUnload() {
  window.currentView.unmount()
}

window.addEventListener("DOMContentLoaded", handleDOMContentLoaded, false)
window.addEventListener("unload", handleDocumentUnload, false)
