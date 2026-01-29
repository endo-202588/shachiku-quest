import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["out", "measure"]
  static values = {
    speed: { type: Number, default: 35 },
    startDelay: { type: Number, default: 0 }
  }

  connect() {
    this._timer = null

    // measure は最初から置いてある前提で「読むだけ」
    let fullText = this.measureTarget.textContent.replace(/^\s+/, "")

    // out 用にだけ変換（measure は触らない）
    fullText = fullText
      .replace(/\[br\]/g, "\n")
      .replace(/\\n/g, "\n")
      .trimEnd()

    // out は空からスタート
    this.outTarget.textContent = ""

    this._startTyping(fullText)
  }

  disconnect() {
    if (this._timer) clearInterval(this._timer)
  }

  _startTyping(fullText) {
    let i = 0

    setTimeout(() => {
      this._timer = setInterval(() => {
        this.outTarget.textContent = fullText.slice(0, i)
        i += 1

        if (i > fullText.length) {
          clearInterval(this._timer)
          this._timer = null   // ← ★ 安全のために null クリア
        }
      }, this.speedValue)
    }, this.startDelayValue)
  }
}
