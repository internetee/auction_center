import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = document.documentElement.classList.contains("debug");
window.Stimulus   = application

// if (process.env.RAILS_ENV === "test") {
//   // propagate errors that happen inside Stimulus controllers
//   application.handleError = (error, message, detail) => {
//     throw error
//   }
// }

export { application }
