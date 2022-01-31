import {Controller} from '@hotwired/stimulus'

export default class extends Controller {
    static get targets() {
        return ['wrapper', 'container', 'content', 'background']
    }

    static get values() {
        return {
            url: String,
            title: String,
            turbo: {type: Boolean, default: true}
        }
    }

    initialize() {
        this.documentOverflowVal = document.body.style.overflow

    }


    view(e) {
        if (e.target !== this.wrapperTarget &&
            !this.wrapperTarget.contains(e.target)) return

        this.wrapperTarget.insertAdjacentHTML('afterbegin', this.template())
        this.getContent(this.urlValue)
        document.body.style.overflow = 'hidden'
    }

    close(e) {
        e.preventDefault()

        if (this.hasContainerTarget) {
            this.containerTarget.remove()
            document.body.style.overflow = this.documentOverflowVal
        }
    }

    closeBackground(e) {
        if (e.target === this.backgroundTarget) {
            this.close(e)
        }
    }

    closeWithKeyboard(e) {
        if (e.keyCode === 27) {
            this.close(e)
        }
    }

    getContent(url) {
        if (this.turboValue) {
            this.contentTarget.innerHTML = `
            <turbo-frame id="modal_content" src=${this.urlValue}>
            Loading..
            </turbo-frame>
            `
            return;
        }
        fetch(url).then(response => {
            if (response.ok) {
                return response.text()
            }
        })
            .then(html => {
                this.contentTarget.innerHTML = html
            })
    }

    template() {
        return `      
        <div data-modal-target='container' class="fixed z-10 inset-0 overflow-y-auto min-h-screen" aria-labelledby="modal-title" role="dialog" aria-modal="true">
          <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
            <div data-modal-target='background' data-action='click->modal#closeBackground' class="fixed inset-0 backdrop-blur-md bg-gray-200/50 bg-opacity-75 transition-opacity" aria-hidden="true"></div>
            <!-- This element is to trick the browser into centering the modal contents. -->
            <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
<!--        REPLACE THE FOLLOWING 2 LINES FOR A DYNAMICALLY SIZED CENTERED MODAL-->
<!--        <div class="inline-block align-bottom bg-white border border-black px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full sm:p-6">-->
            <div class="absolute top-0 bottom-0 left-0 right-0 p-4 m-4 md:mx-auto md:my-12 align-bottom bg-white rounded-md border border-black text-left overflow-y-scroll shadow-xl transform transition-all sm:align-middle sm:max-w-lg sm:w-full sm:p-6">
                    <div class="flex justify-between">
                    <div class="py-2 font-semibold text-2xl">${this.titleValue}</div>
                    <button data-action='click->modal#close' type="button" class="text-black hover:text-gray-500 focus:outline-none focus:ring-none">
                        <span class="sr-only">Close</span>
                   <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
</svg>
                    </button>
                </div>
                <div data-modal-target='content'></div>
            </div>
          </div>
        </div>
    `
    }
}