import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container", "template"];
  static values = {
    maxTasks: { type: Number, default: 10 },
    minTasks: { type: Number, default: 1 },
  };

  add(event) {
    event.preventDefault();

    const taskCount =
      this.containerTarget.querySelectorAll(".task-field").length;

    // 最大数チェック
    if (taskCount >= this.maxTasksValue) {
      alert(`タスクは最大${this.maxTasksValue}個までです`);
      return;
    }

    // テンプレートをクローン
    const template = this.templateTarget.content.cloneNode(true);
    this.containerTarget.appendChild(template);

    // 新しく追加したフィールドにフォーカス
    const lastField = this.containerTarget.lastElementChild;
    const firstInput = lastField.querySelector("input[name='tasks[][title]']");
    if (firstInput) {
      firstInput.focus();
    }
  }

  remove(event) {
    event.preventDefault();

    const taskFields = this.containerTarget.querySelectorAll(".task-field");

    // 最低数チェック
    if (taskFields.length <= this.minTasksValue) {
      alert(`タスクは最低${this.minTasksValue}つ必要です`);
      return;
    }

    // 削除対象の要素を取得して削除
    const taskField = event.target.closest(".task-field");
    if (taskField) {
      taskField.remove();
    }
  }
}
