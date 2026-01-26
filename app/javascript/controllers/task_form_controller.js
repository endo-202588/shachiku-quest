import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["taskTypeSelect", "requiredTimeField", "requiredTimeInput", "requestMessageField", "requestMessageInput", "virtuePointsInput"];

  connect() {
    this.toggleRequiredTime();
  }

  toggleRequiredTime() {
    const isHelpRequest = this.taskTypeSelectTarget.value === "help_request";

    if (isHelpRequest) {
      this.requiredTimeFieldTarget.classList.remove("hidden");
      this.requestMessageFieldTarget.classList.remove("hidden");
      his.virtuePointsFieldTarget.classList.remove("hidden");
      setTimeout(() => this.requiredTimeInputTarget.focus(), 100);
    } else {
      this.requiredTimeFieldTarget.classList.add("hidden");
      this.requestMessageFieldTarget.classList.add("hidden");
      this.requiredTimeInputTarget.value = "";
      this.requestMessageInputTarget.value = "";
      this.virtuePointsInputTarget.value = "";
    }
  }
}
