import { Controller } from "@hotwired/stimulus"
import Pagy from "lib/pagy_lib"  // if using sprockets, you can remove above line, but make sure you have the appropriate directive if your manifest.js file.

export default class extends Controller {
  connect() {
    window.addEventListener("turbolinks:load", Pagy.init)
   }
}