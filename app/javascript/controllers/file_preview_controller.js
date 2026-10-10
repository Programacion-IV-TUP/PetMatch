import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "filename", "previewContainer"]

    connect() {
        this.selectedFiles = new DataTransfer()
    }

    change(event) {
        const files = Array.from(event.target.files)
        if (!files.length) return

        files.forEach((file) => {
            if (!file.type.startsWith("image/")) return

            // Límite de 5 fotos máximo
            if (this.selectedFiles.files.length < 5) {
                this.selectedFiles.items.add(file)
                this.createPreviewWrapper(file)
            }
        })

        // Sincronizamos los archivos acumulados con el input de HTML
        this.inputTarget.files = this.selectedFiles.files
        this.updateFilenameLabel()
    }

    createPreviewWrapper(file) {
        const reader = new FileReader()

        reader.onload = (e) => {
            const wrapper = document.createElement("div")
            wrapper.className = "relative group w-20 h-20 local-preview"

            const img = document.createElement("img")
            img.src = e.target.result
            img.className = "w-20 h-20 rounded-xl object-cover border border-slate-200 shadow-sm"
            img.alt = file.name

            // Botón para desestimar la foto seleccionada localmente
            const removeBtn = document.createElement("button")
            removeBtn.type = "button"
            removeBtn.className = "absolute -top-1.5 -right-1.5 w-5 h-5 bg-rose-500 hover:bg-rose-600 text-white rounded-full flex items-center justify-center text-[10px] font-bold shadow-xs transition cursor-pointer"
            removeBtn.innerHTML = "✕"

            removeBtn.addEventListener("click", () => {
                this.removeFile(file, wrapper)
            })

            wrapper.appendChild(img)
            wrapper.appendChild(removeBtn)
            this.previewContainerTarget.appendChild(wrapper)
        }

        reader.readAsDataURL(file)
    }

    removeFile(fileToRemove, wrapperElement) {
        const dt = new DataTransfer()

        // Reconstruimos la lista excluyendo el archivo eliminado
        Array.from(this.selectedFiles.files).forEach((file) => {
            if (file !== fileToRemove) {
                dt.items.add(file)
            }
        })

        this.selectedFiles = dt
        this.inputTarget.files = this.selectedFiles.files
        wrapperElement.remove()
        this.updateFilenameLabel()
    }

    updateFilenameLabel() {
        if (this.hasFilenameTarget) {
            const count = this.selectedFiles.files.length
            this.filenameTarget.textContent = count > 0 ? `${count} archivo(s) seleccionado(s)` : ""
        }
    }
}