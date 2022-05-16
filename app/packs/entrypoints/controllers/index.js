// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import HelloController from "./hello_controller"
application.register("hello", HelloController)
import DebounceController from "./debounce_controller"
application.register("debounce", DebounceController)
import CheckController from "./check_controller"
application.register("check", CheckController)
import SubmitterController from "./submitter_controller"
application.register("submitter", SubmitterController)
import CheckerController from "./checker_controller"
application.register("checker", CheckerController)
