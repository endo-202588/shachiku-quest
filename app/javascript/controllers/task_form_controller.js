import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["taskTypeSelect", "requiredTimeField", "requiredTimeInput"];

  connect() {
    this.toggleRequiredTime();
  }

  toggleRequiredTime() {
    const isHelpRequest = this.taskTypeSelectTarget.value === "help_request";

    if (isHelpRequest) {
      this.requiredTimeFieldTarget.classList.remove("hidden");
      setTimeout(() => {
        this.requiredTimeInputTarget.focus();
      }, 100);
    } else {
      this.requiredTimeFieldTarget.classList.add("hidden");
      this.requiredTimeInputTarget.value = "";
    }
  }
}
