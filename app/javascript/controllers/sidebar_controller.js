import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggleButton", "iconExpand", "iconCollapse"]

  connect() {
    this.storageKey = "admin.sidebar.minified"
    this.preferredMinified = this.readPersistedState()
    this.desktopMediaQuery = window.matchMedia("(min-width: 1024px)")
    this.handleBreakpointChange = () => this.syncState()

    if (this.desktopMediaQuery.addEventListener) {
      this.desktopMediaQuery.addEventListener("change", this.handleBreakpointChange)
    } else {
      this.desktopMediaQuery.addListener(this.handleBreakpointChange)
    }

    this.syncState()
  }

  disconnect() {
    if (!this.desktopMediaQuery || !this.handleBreakpointChange) return

    if (this.desktopMediaQuery.removeEventListener) {
      this.desktopMediaQuery.removeEventListener("change", this.handleBreakpointChange)
    } else {
      this.desktopMediaQuery.removeListener(this.handleBreakpointChange)
    }
  }

  toggle(event) {
    if (event) event.preventDefault()

    this.preferredMinified = !this.preferredMinified
    this.persistState(this.preferredMinified)
    this.syncState()
  }

  isDesktop() {
    return this.desktopMediaQuery ? this.desktopMediaQuery.matches : window.matchMedia("(min-width: 1024px)").matches
  }

  syncState() {
    const desktop = this.isDesktop()
    const shouldApplyMinifiedLayout = this.preferredMinified && desktop

    this.element.classList.toggle("minified", shouldApplyMinifiedLayout)

    // Keep desktop width transitions responsive-aware to avoid fighting base mobile width classes.
    this.element.classList.toggle("lg:w-16", shouldApplyMinifiedLayout)
    this.element.classList.toggle("lg:w-64", desktop && !shouldApplyMinifiedLayout)
    this.element.classList.remove("w-16", "w-64")

    if (!desktop) {
      this.element.classList.remove("lg:w-16", "lg:w-64")
    }

    if (typeof window.HSOverlay !== "undefined") {
      window.HSOverlay.minify(this.element, shouldApplyMinifiedLayout)
    }

    document.body.classList.toggle("hs-overlay-minified", shouldApplyMinifiedLayout)

    const adminShell = document.getElementById("admin-shell")
    if (adminShell) {
      adminShell.classList.toggle("admin-shell-sidebar-minified", shouldApplyMinifiedLayout)
    }

    if (this.hasIconExpandTarget) {
      this.iconExpandTarget.classList.toggle("hidden", !this.preferredMinified)
    }

    if (this.hasIconCollapseTarget) {
      this.iconCollapseTarget.classList.toggle("hidden", this.preferredMinified)
    }

    this.syncToggleButton(this.preferredMinified)
  }

  syncToggleButton(minified = this.preferredMinified) {
    if (!this.hasToggleButtonTarget) return

    this.toggleButtonTarget.setAttribute("aria-expanded", String(!minified))
    this.toggleButtonTarget.setAttribute(
      "aria-label",
      minified ? "Expandir menu lateral" : "Recolher menu lateral"
    )
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
