// Entry point for the build script in your package.json
import "./turbo_streams"
import "@hotwired/turbo-rails"
import "./controllers"

import { StreamActions } from "@hotwired/turbo"
 
Turbo.StreamActions.redirect = function () {
  Turbo.visit(this.target);
};
