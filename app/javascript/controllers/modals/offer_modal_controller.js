import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    classNameAttr: String
  }

  connect() {
    const modal = document.querySelector(`.${this.classNameAttrValue}`);

    modal.classList.toggle('is-open');
    document.querySelector('.js-close-modal').addEventListener('click', function() {
      modal.classList.toggle('is-open');
    });


    // const jsModalToggle = document.querySelectorAll('.js-modal-toggle');
    // const jsModalTogglePo = document.querySelectorAll('.js-modal-toggle-po');
    // const jsEditModalToggle = document.querySelectorAll('.js-edit-modal-toggle');
    // const jsModalDeleteToggle = document.querySelectorAll('.js-modal-delete-toggle');
    
    // jsModalToggle.forEach((toggle) => {
      //   toggle.addEventListener('click', (event) => {
        //     event.preventDefault();
    //     const modal = document.querySelector('.js-modal');
    //     modal.classList.toggle('is-open');
    //   });
    // });
    
    // jsModalTogglePo.forEach((toggle) => {
      //   toggle.addEventListener('click', (event) => {
        //     event.preventDefault();
        //     const modal = document.querySelector('.js-modal-po');
        //     modal.classList.toggle('is-open');
        //   });
        // });
        
        // jsEditModalToggle.forEach((toggle) => {
          //   toggle.addEventListener('click', (event) => {
            //     event.preventDefault();
            //     const modal = document.querySelector('.js-modal-edit');
            //     modal.classList.toggle('is-open');
            //   });
            // });
            
            // jsModalDeleteToggle.forEach((toggle) => {
              //   toggle.addEventListener('click', (event) => {
                //     event.preventDefault();
                //     const modal = document.querySelector('.js-modal-delete');
                //     modal.classList.toggle('is-open');
                //   });
                // });
                
  }
}
