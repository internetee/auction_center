// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import Modals__OfferModalController from "./modals/offer_modal_controller";
application.register("modals--offer-modal", Modals__OfferModalController);

import Form__DebounceController from "./form/debounce_controller"
application.register("form--debounce", Form__DebounceController)

import Form__FilterController from "./form/filter_controller"
application.register("form--filter", Form__FilterController)
