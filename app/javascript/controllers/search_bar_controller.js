import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static get targets() {
        return ["input", "reset"]
    }

    initialize(){
        this.inputTarget.focus()
    }

    reset(){
        this.inputTarget.value = ''
    }
}