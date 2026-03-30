import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggleButton"]

  connect() {
    this.syncToggleButton()
  }

  toggle() {
    this.element.classList.toggle("collapsed")
    this.syncToggleButton()
  }

  syncToggleButton() {
    if (!this.hasToggleButtonTarget) return

    const collapsed = this.element.classList.contains("collapsed")

    this.toggleButtonTarget.setAttribute("aria-expanded", String(!collapsed))
    this.toggleButtonTarget.setAttribute(
      "aria-label",
      collapsed ? "Expandir menu lateral" : "Recolher menu lateral"
    )
  }
}
