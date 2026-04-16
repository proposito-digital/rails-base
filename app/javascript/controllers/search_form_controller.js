import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  forceSubmit(event) {
    event.preventDefault()

    if (!(this.element instanceof HTMLFormElement)) return

    const termField = this.element.querySelector('input[name="term"]')
    if (termField instanceof HTMLInputElement) {
      termField.value = termField.value.trim()
    }

    if (typeof this.element.requestSubmit === "function") {
      this.element.requestSubmit()
    } else {
      this.element.submit()
    }
  }
}
