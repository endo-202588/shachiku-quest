import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // 初期表示でも一番下へ
    this.scrollToBottom();

    // 子要素が追加されたら一番下へ（Turbo Stream append 対応）
    this.observer = new MutationObserver(() => this.scrollToBottom());
    this.observer.observe(this.element, { childList: true, subtree: true });
  }

  disconnect() {
    if (this.observer) this.observer.disconnect();
  }

  scrollToBottom() {
    // chat_messages 自体がスクロール領域の場合
    this.element.scrollTop = this.element.scrollHeight;

    // もし chat_messages がスクロール領域じゃない(高さ固定してない)なら
    // 次の1行に差し替えると「画面」自体が下へ行きます：
    // this.element.lastElementChild?.scrollIntoView({ block: "end" })
  }
}
