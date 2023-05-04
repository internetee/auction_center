// app/javascript/controllers/debounce_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  notificationTargetConnected(target) {
    let el = target.querySelector('#flash');
    let text = el.textContent;
    let textTemaplate = target.parentNode.dataset.outbidMessage;

    let parsedText = text.split(', ');
    if(parsedText[0] === 'websocket_domain_name') {
      el.textContent = textTemaplate.replace(/{domain_name}/g, parsedText[1])
    }
  }
}
