require 'constraints/administrator'

# disallowed_auction_actions = if Feature.registry_integration_enabled?
#                                %i[new create edit update destroy]
#                              else
#                                %i[edit update]
#                              end

Rails.application.routes.draw do
  namespace :admin do
    get 'finished_auctions/index'
  end
  mount ActionCable.server => '/cable'

  get 'unsubscribe/unsubscribe'
  patch 'unsubscribe/update'
  root to: 'auctions#index'

  concern :auditable do
    resources :versions, only: :index
  end

  match 'profile/edit', via: :get, to: 'users#edit_authwall', as: :user_edit_authwall
  match '/profile/toggle_subscription', via: :get, to: 'users#toggle_subscription',
        as: :user_toggle_sub

  namespace :eis_billing, defaults: { format: 'json' } do
    put '/payment_status', to: 'payment_status#update', as: 'payment_status'
    put '/directo_response', to: 'directo_response#update', as: 'directo_response'
  end

  namespace :admin, constraints: Constraints::Administrator.new do
    resources :auctions, concerns: %i[auditable] do
    collection do
      post 'bulk_starts_at', to: 'auctions#bulk_starts_at', as: 'bulk_starts_at'
    end
  end

    resources :bans, except: %i[new show edit update], concerns: %i[auditable]
    resources :statistics, only: :index
    resources :billing_profiles, only: %i[index show], concerns: %i[auditable]
    resources :invoices, except: %i[new create destroy], concerns: %i[auditable] do
      member do
        get 'download'
      end
    end
    resources :jobs, only: %i[index create]
    resources :offers, only: [:show], concerns: [:auditable]
    resources :results, only: %i[index create show], concerns: %i[auditable]

    resources :settings, except: %i[create destroy], concerns: [:auditable]
    resources :users, concerns: %i[auditable]
  end

  devise_scope :user do
    match '/auth/tara/callback', via: %i[get post], to: 'auth/tara#callback', as: :tara_callback
    match '/auth/tara/cancel', via: %i[get post delete], to: 'auth/tara#cancel',
                               as: :tara_cancel
    match '/auth/tara/create', via: [:post], to: 'auth/tara#create', as: :tara_create
  end

  devise_for :users, path: 'sessions',
                     controllers: { confirmations: 'email_confirmations', sessions: 'auth/sessions' }

  resources :auctions, only: %i[index show], param: :uuid do
    resources :offers, only: %i[new show create edit update destroy], shallow: true, param: :uuid
    resources :english_offers, only: %i[new show create edit update destroy], shallow: true, param: :uuid
  end
  match '*auctions', controller: 'auctions', action: 'cors_preflight_check', via: [:options]

  resources :billing_profiles, param: :uuid
  match '/status', via: :get, to: 'health_checks#index'


  resources :invoices, only: %i[show edit update index], param: :uuid do
    member do
      get 'download'
      post 'oneoff'
    end

    collection do
      post 'invoices/pay_all_bills', to: 'invoices#pay_all_bills', as: 'pay_all_bills'
    end

    resources :payment_orders, only: %i[new show create], shallow: true, param: :uuid do
      member do
        # get 'return'
        # put 'return'
        # post 'return'

        post 'callback'
      end
    end
  end

  match '/linkpay_callback', via: %i[get], to: 'linkpay#callback', as: :linkpay_callback

  resource :locale, only: :update
  resources :offers, only: :index
  resources :results, only: :show, param: :uuid

  resources :users, param: :uuid do
    resources :phone_confirmations, only: %i[new create]
  end

  resources :wishlist_items, param: :uuid, only: %i[index create destroy update]

  mount OkComputer::Engine, at: '/healthcheck', as: :healthcheck
end
