import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "showIcon", "hideIcon"]

  toggle() {
    if (!this.hasInputTarget) return

    const passwordHidden = this.inputTarget.type === "password"
    this.inputTarget.type = passwordHidden ? "text" : "password"

    if (this.hasShowIconTarget) {
      this.showIconTarget.classList.toggle("hidden", passwordHidden)
    }

    if (this.hasHideIconTarget) {
      this.hideIconTarget.classList.toggle("hidden", !passwordHidden)
    }

    this.element
      .querySelector("button")
      ?.setAttribute("aria-label", passwordHidden ? "Ocultar senha" : "Mostrar senha")
  }
}
