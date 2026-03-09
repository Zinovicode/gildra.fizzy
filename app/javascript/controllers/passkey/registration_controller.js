import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["error", "cancelled"]

  showError({ detail: { cancelled } }) {
    this.errorTarget.hidden = cancelled
    this.cancelledTarget.hidden = !cancelled
  }
}
