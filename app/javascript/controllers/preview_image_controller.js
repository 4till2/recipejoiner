import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static get targets() {
        return ["input", "output"]
    }

    readURL() {
        let input = this.inputTarget
        let output = this.outputTarget

        if (input.files && input.files[0]) {
            let reader = new FileReader();

            reader.onload = function () {
                output.src = reader.result
            }

            reader.readAsDataURL(input.files[0]);
        }
    }
}