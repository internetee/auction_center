import { Application } from "@hotwired/stimulus"

import { Turbo } from "@hotwired/turbo-rails"

Turbo.session.drive = true

const application = Application.start()

// Configure Stimulus development experience1
application.debug = false
window.Stimulus   = application

export { application }
