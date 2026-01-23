import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container", "template"];
  static values = {
    maxTasks: { type: Number, default: 10 },
    minTasks: { type: Number, default: 1 },
  };

  connect() {
    // 初期表示時のチェック
    this.checkAllStatusFields();
  }

  add(event) {
    event.preventDefault();

    const taskCount = this.containerTarget.querySelectorAll(".task-field").length;

    if (taskCount >= this.maxTasksValue) {
      alert(`タスクは最大${this.maxTasksValue}個までです`);
      return;
    }

    const template = this.templateTarget.content.cloneNode(true);
    this.containerTarget.appendChild(template);

    const lastField = this.containerTarget.lastElementChild;
    const firstInput = lastField.querySelector("input[name='tasks[][title]']");
    if (firstInput) {
      firstInput.focus();
    }

    // 新しく追加したフィールドの監視設定
    this.setupStatusListener(lastField);
  }

  remove(event) {
    event.preventDefault();

    const taskFields = this.containerTarget.querySelectorAll(".task-field");

    if (taskFields.length <= this.minTasksValue) {
      alert(`タスクは最低${this.minTasksValue}つ必要です`);
      return;
    }

    const taskField = event.target.closest(".task-field");
    if (taskField) {
      taskField.remove();
    }
  }

  // 全てのステータスフィールドをチェック
  checkAllStatusFields() {
    const taskFields = this.containerTarget.querySelectorAll(".task-field");
    taskFields.forEach((field) => {
      this.setupStatusListener(field);
      this.toggleRequiredTime(field);
    });
  }

  // ステータスフィールドの変更を監視
  setupStatusListener(taskField) {
    const statusSelect = taskField.querySelector("select[name='tasks[][status]']");
    if (statusSelect && !statusSelect.dataset.listenerAttached) {
      statusSelect.addEventListener("change", () => {
        this.toggleRequiredTime(taskField);
      });
      statusSelect.dataset.listenerAttached = "true";
    }
  }

  // 必要時間フィールドの表示/非表示を切り替え
  toggleRequiredTime(taskField) {
    const statusSelect = taskField.querySelector("select[name='tasks[][status]']");
    const requiredTimeField = taskField.querySelector("select[name='tasks[][required_time]']")?.closest(".flex.flex-col");
    const requestMessageField = taskField.querySelector("textarea[name='tasks[][request_message]']")?.closest(".flex.flex-col");

    if (!statusSelect) return;

    const show = statusSelect.value === "help_request";

    if (requiredTimeField) requiredTimeField.style.display = show ? "flex" : "none";
    if (requestMessageField) requestMessageField.style.display = show ? "flex" : "none";
  }
}