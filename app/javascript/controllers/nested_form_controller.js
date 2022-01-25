import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static get targets() {
        return ["fields"]
    }

    addField(e) {
        if (!e) return;

        e.preventDefault();
        let time = new Date().getTime();
        let linkId = e.target.dataset.id;
        let regexp = linkId ? new RegExp(linkId, "g") : null;
        let newFields = regexp ? e.target.dataset.fields.replace(regexp, time) : null;
        newFields ? this.fieldsTarget.insertAdjacentHTML("beforeend", newFields) : null;
    }

    removeField(e) {
        if (!e) return;

        e.preventDefault();
        let fieldParent = e.target.closest(".nested-field");
        let deleteField = fieldParent
            ? fieldParent.querySelector('input[type="hidden"]')
            : null;
        if (deleteField) {
            deleteField.value = 1;
            fieldParent.style.display = "none";
        }
    }
}