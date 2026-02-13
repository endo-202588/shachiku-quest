import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this._onClickOutside = this.onClickOutside.bind(this)
    document.addEventListener("click", this._onClickOutside)
  }

  disconnect() {
    document.removeEventListener("click", this._onClickOutside)
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    this.menuTarget.classList.toggle("hidden")
  }

  onClickOutside(event) {
    // ドロップダウンの外をクリックしたら閉じる
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }
}
