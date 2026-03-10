import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  edit() {
    this.formTarget.classList.remove("hidden")
  }

  cancel() {
    this.formTarget.classList.add("hidden")
  }
}