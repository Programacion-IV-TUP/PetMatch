import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["notification"]

    connect() {
        // Autoclose flash notice/alert after 5 seconds
        this.timeout = setTimeout(() => {
            this.close()
        }, 5000)
    }

    close() {
        if (this.hasNotificationTarget) {
            this.notificationTarget.classList.add("opacity-0", "translate-y-2")
            setTimeout(() => {
                this.element.remove()
            }, 300)
        }
    }

    disconnect() {
        if (this.timeout) {
            clearTimeout(this.timeout)
        }
    }
}