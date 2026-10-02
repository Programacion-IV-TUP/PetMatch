import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "filename", "previewContainer"]

    change(event) {
        const files = Array.from(this.inputTarget.files)

        if (files.length === 0) return

        // 1. file name
        if (this.hasFilenameTarget) {
            if (files.length === 1) {
                this.filenameTarget.textContent = files[0].name
            } else {
                this.filenameTarget.textContent = `${files.length} archivos seleccionados`
            }
        }

        // 2. Image preview
        if (this.hasPreviewContainerTarget) {
            this.previewContainerTarget.innerHTML = "" // clear previous

            files.forEach(file => {
                if (!file.type.startsWith("image/")) return

                const reader = new FileReader()
                reader.onload = (e) => {
                    const img = document.createElement("img")
                    img.src = e.target.result
                    img.className = "w-16 h-16 object-cover rounded-xl border border-slate-200 shadow-xs"
                    this.previewContainerTarget.appendChild(img)
                }
                reader.readAsDataURL(file)
            })
        }
    }
}