import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.scrollToBottomSoon();

    this.observer = new MutationObserver(() => this.scrollToBottomSoon());
    this.observer.observe(this.element, { childList: true, subtree: true });
  }

  disconnect() {
    this.observer?.disconnect();
  }

  scrollToBottomSoon() {
    cancelAnimationFrame(this.raf);
    this.raf = requestAnimationFrame(() => this.scrollToBottom());
  }

  scrollToBottom() {
    this.element.scrollTop = this.element.scrollHeight;
  }
}
