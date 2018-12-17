require 'constraints/administrator'

Rails.application.routes.draw do
  root to: 'auctions#index'
  devise_for :users, path: 'sessions'

  concern :auditable do
    resources :versions, only: :index
  end

  namespace :admin, constraints: Constraints::Administrator.new do
    resources :auctions, except: %i[edit update], concerns: [:auditable]
    resources :billing_profiles, only: :index, concerns: [:auditable]
    resources :invoices, only: %i[index show], concerns: [:auditable]
    resources :jobs, only: %i[index create]
    resources :offers, only: [:show], concerns: [:auditable]
    resources :results, only: %i[index create show], concerns: [:auditable]
    resources :settings, except: %i[create destroy], concerns: [:auditable]
    resources :users, concerns: [:auditable]
  end

  resources :auctions, only: %i[index show] do
    resources :offers, only: %i[new show create edit update destroy], shallow: true
  end

  resources :billing_profiles

  resources :invoices, only: %i[show edit update index] do
    resources :payment_orders, only: %i[new show create] do
      member do
        get "return"
        put "return"
        post "return"

        post "callback"
      end
    end
  end

  resources :offers, only: :index
  resources :results, only: :show
  resources :users, param: :uuid
end
