import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "filename"]

  updateFilename() {
    const file = this.inputTarget.files?.[0]
    if (file) {
      this.filenameTarget.textContent = file.name
    }
    // file がない場合は、サーバー側が描いた初期テキストを維持する
  }
}
