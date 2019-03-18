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

  namespace :admin, constraints: Constraints::Administrator.new do
    resources :auctions, except: disallowed_auction_actions, concerns: [:auditable] do
      collection do
        post "search"
      end
    end

    resources :bans, except: %i[new show edit update], concerns: [:auditable]
    resources :billing_profiles, only: :index, concerns: [:auditable]
    resources :invoices, only: %i[index show], concerns: [:auditable] do
      collection do
        post "search"
      end
    end
    resources :jobs, only: %i[index create]
    resources :offers, only: [:show], concerns: [:auditable]
    resources :results, only: %i[index create show], concerns: [:auditable]
    resources :settings, except: %i[create destroy], concerns: [:auditable]
    resources :users, concerns: [:auditable] do
      collection do
        post "search"
      end
    end
  end

  devise_scope :user do
    match "/auth/tara/callback", via: [:get, :post], to: "auth/tara#callback", as: :tara_callback
    match "/auth/tara/cancel", via: [:get, :post, :delete], to: "auth/tara#cancel",
                               as: :tara_cancel
    match "/auth/tara/create", via: [:post], to: "auth/tara#create", as: :tara_create
  end

  devise_for :users, path: "sessions", controllers: { confirmations: "email_confirmations" }

  resources :auctions, only: %i[index show], param: :uuid do
    collection do
      post "search"
    end

    resources :offers, only: %i[new show create edit update destroy], shallow: true, param: :uuid
  end
  match "*auctions", controller: "auctions", action: "cors_preflight_check", via: [:options]

  resources :billing_profiles, param: :uuid

  resources :invoices, only: %i[show edit update index], param: :uuid do
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
end
