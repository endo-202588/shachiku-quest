import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "filename"]

  connect() {
    this.updateFilename()
  }

  updateFilename(event) {
    const input = event?.target || this.inputTarget
    const file = input.files?.[0]
    this.filenameTarget.textContent = file ? file.name : "未選択"
  }
}
