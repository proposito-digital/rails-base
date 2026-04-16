import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggleButton", "iconExpand", "iconCollapse"]

  connect() {
    this.storageKey = "admin.sidebar.minified"
    this.restorePersistedState()
    this.syncState()
  }

  toggle(event) {
    if (event) event.preventDefault()

    const nextMinified = !this.isMinified()

    if (typeof window.HSOverlay !== "undefined") {
      window.HSOverlay.minify(this.element, nextMinified)
    }

    this.element.classList.toggle("minified", nextMinified)
    this.syncState()
  }

  isMinified() {
    return this.element.classList.contains("minified")
  }

  syncState() {
    const minified = this.isMinified()

    this.element.classList.toggle("w-16", minified)
    this.element.classList.toggle("w-64", !minified)
    document.body.classList.toggle("hs-overlay-minified", minified)

    const adminShell = document.getElementById("admin-shell")
    if (adminShell) {
      adminShell.classList.toggle("admin-shell-sidebar-minified", minified)
    }

    if (this.hasIconExpandTarget) {
      this.iconExpandTarget.classList.toggle("hidden", !minified)
    }

    if (this.hasIconCollapseTarget) {
      this.iconCollapseTarget.classList.toggle("hidden", minified)
    }

    this.syncToggleButton(minified)
    this.persistState(minified)
  }

  syncToggleButton(minified = this.isMinified()) {
    if (!this.hasToggleButtonTarget) return

    this.toggleButtonTarget.setAttribute("aria-expanded", String(!minified))
    this.toggleButtonTarget.setAttribute(
      "aria-label",
      minified ? "Expandir menu lateral" : "Recolher menu lateral"
    )
  }

  restorePersistedState() {
    const persistedMinified = this.readPersistedState()

    if (typeof window.HSOverlay !== "undefined") {
      window.HSOverlay.minify(this.element, persistedMinified)
    }

    this.element.classList.toggle("minified", persistedMinified)
  }

  readPersistedState() {
    try {
      return window.localStorage.getItem(this.storageKey) === "1"
    } catch (_error) {
      return false
    }
  }

  persistState(minified) {
    try {
      window.localStorage.setItem(this.storageKey, minified ? "1" : "0")
    } catch (_error) {
      // Ignore storage errors (private mode, blocked storage, etc.)
    }
  }
}
