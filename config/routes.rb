require "constraints/administrator"

disallowed_auction_actions = if Feature.registry_integration_enabled?
                               %i[new create edit update destroy]
                             else
                               %i[edit update]
                             end

Rails.application.routes.draw do
  root to: "auctions#index"

  concern :auditable do
    resources :versions, only: :index
  end

  concern :searchable do
    collection do
      get 'search'
    end
  end

  namespace :admin, constraints: Constraints::Administrator.new do
    resources :auctions, except: disallowed_auction_actions, concerns: [:auditable, :searchable]

    resources :bans, except: %i[new show edit update], concerns: [:auditable]
    resources :billing_profiles, only: %i[index show], concerns: [:auditable]
    resources :invoices, except: %i[new create destroy], concerns: [:auditable, :searchable] do
      member do
        get "download"
      end
    end
    resources :jobs, only: %i[index create]
    resources :offers, only: [:show], concerns: [:auditable]
    resources :results, only: %i[index create show], concerns: [:auditable, :searchable]

    resources :settings, except: %i[create destroy], concerns: [:auditable]
    resources :users, concerns: [:auditable, :searchable]
  end

  devise_scope :user do
    match "/auth/tara/callback", via: [:get, :post], to: "auth/tara#callback", as: :tara_callback
    match "/auth/tara/cancel", via: [:get, :post, :delete], to: "auth/tara#cancel",
                               as: :tara_cancel
    match "/auth/tara/create", via: [:post], to: "auth/tara#create", as: :tara_create
  end

  devise_for :users, path: "sessions",
    controllers: { confirmations: "email_confirmations", sessions: "auth/sessions" }

  resources :auctions, only: %i[index show], param: :uuid, concerns: [:searchable] do
    resources :offers, only: %i[new show create edit update destroy], shallow: true, param: :uuid
  end
  match "*auctions", controller: "auctions", action: "cors_preflight_check", via: [:options]

  resources :billing_profiles, param: :uuid

  resources :invoices, only: %i[show edit update index], param: :uuid do
    member do
      get "download"
    end

    resources :payment_orders, only: %i[new show create], shallow: true, param: :uuid do
      member do
        get "return"
        put "return"
        post "return"

        post "callback"
      end
    end
  end

  resource :locale, only: :update
  resources :offers, only: :index
  resources :results, only: :show, param: :uuid

  resources :users, param: :uuid do
    resources :phone_confirmations, only: %i[new create]
  end

  mount OkComputer::Engine, at: "/healthcheck"
end
