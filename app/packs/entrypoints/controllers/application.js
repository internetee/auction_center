import { Application } from "@hotwired/stimulus"

const application = Application.start()

import { Turbo } from "@hotwired/turbo-rails"


Turbo.session.drive = true

// Configure Stimulus development experience1
application.debug = false
window.Stimulus   = application

export { application }
