import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  search() {
    const query = this.inputTarget.value
    const url = this.element.dataset.autocompleteUrl

    if (query.length < 1) {
      this.resultsTarget.innerHTML = ""
      return
    }

    fetch(`${url}?q=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => {
        this.resultsTarget.innerHTML = ""

        data.forEach(item => {
          const div = document.createElement("div")
          div.textContent = item.name || item.title
          div.className = "px-3 py-1 hover:bg-sky-100 cursor-pointer"

          div.addEventListener("click", () => {
            this.inputTarget.value = item.last_name || item.title
            this.resultsTarget.innerHTML = ""

            this.inputTarget.form.requestSubmit()
          })

          this.resultsTarget.appendChild(div)
        })
      })
  }
}