// app/javascript/controllers/message_form_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  submit(event) {
    event.preventDefault()           // stop any navigation
    event.stopImmediatePropagation()

    const form = event.currentTarget
    const input = this.inputTarget
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content

    if (!input.value.trim()) return   // don't send empty messages

    fetch(form.action, {
      method: "POST",
      body: new FormData(form),
      headers: {
        "X-CSRF-Token": csrfToken,
        "Accept": "text/html"
      },
      credentials: "same-origin"
    })
        .then(response => {
          if (response.ok) {
            // Clear input immediately (optimistic UI)
            input.value = ""
            input.focus()
            // The new message will appear via Action Cable in ~100ms for BOTH users
          } else {
            console.error("Failed to send message")
          }
        })
        .catch(error => {
          console.error("Error sending message:", error)
        })
  }
}