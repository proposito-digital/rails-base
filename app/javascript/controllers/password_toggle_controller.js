import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "icon"]

  toggle() {
    if (!this.hasInputTarget || !this.hasIconTarget) return

    const hidden = this.inputTarget.type === "password"
    this.inputTarget.type = hidden ? "text" : "password"

    this.iconTarget.classList.toggle("bi-eye", !hidden)
    this.iconTarget.classList.toggle("bi-eye-slash", hidden)

    this.element
      .querySelector("button")
      ?.setAttribute("aria-label", hidden ? "Ocultar senha" : "Mostrar senha")
  }
}
