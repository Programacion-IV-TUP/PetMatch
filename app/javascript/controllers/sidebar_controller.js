import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "backdrop"]

  toggle() {
    this.menuTarget.classList.toggle("-translate-x-full")
    this.backdropTarget.classList.toggle("hidden")
  }

  close() {
    this.menuTarget.classList.add("-translate-x-full")
    this.backdropTarget.classList.add("hidden")
  }
}