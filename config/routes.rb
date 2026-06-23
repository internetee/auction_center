require 'constraints/administrator'

Rails.application.routes.draw do
  namespace :admin do
    get 'finished_auctions/index'
  end
  # mount ActionCable.server => '/cable'

  get 'unsubscribe/unsubscribe'
  patch 'unsubscribe/update'
  root to: 'auctions#index'

  concern :auditable do
    resources :versions, only: :index
  end

  resources :histories, only: :index do
    resources :bids, only: :show
  end

  resources :notifications, only: :index do
    scope module: :notifications do
      patch :mark_as_read, to: 'mark_as_read#update', on: :collection
    end
  end

  get 'domain_wishlist_availability', to: 'wishlist_items#domain_wishlist_availability', as: :domain_wishlist_availability

  resource :push_subscriptions, only: %i[create destroy]
  # delete 'push_subscriptions', to: 'push_subscriptions#destroy', on: :collection
  get '/service-worker.js', to: 'service_workers/workers#index'
  get '/manifest.json', to: 'service_workers/manifests#index'

  match 'profile/edit', via: :get, to: 'users#edit_authwall', as: :user_edit_authwall
  match '/profile/toggle_subscription', via: :get, to: 'users#toggle_subscription',
        as: :user_toggle_sub

  namespace :eis_billing, defaults: { format: 'json' } do
    put '/payment_status', to: 'payment_status#update', as: 'payment_status'
    put '/directo_response', to: 'directo_response#update', as: 'directo_response'
    put '/e_invoice_response', to: 'e_invoice_response#update', as: 'e_invoice_response'
    resource :invoices, only: %i[update]
    resources :lhv_connect_transactions, only: :create
  end

  namespace :admin, constraints: Constraints::Administrator.new do
    resources :auctions, concerns: %i[auditable] do
      collection do
        post 'bulk_starts_at', to: 'auctions#bulk_starts_at', as: 'bulk_starts_at'
        post 'apply_auction_participants', to: 'auctions#apply_auction_participants', as: 'apply_auction_participants'
      end
    end

    resources :bans, except: %i[new show edit update], concerns: %i[auditable]
    resources :statistics, only: :index
    resources :billing_profiles, only: %i[index show], concerns: %i[auditable]
    resources :invoices, except: %i[new create destroy], concerns: %i[auditable] do
      scope module: :invoices do
        resource :mark_as_paid, only: %i[edit update]
        resource :toggle_partial_payment, only: %i[update]
      end

      member do
        get 'download'
      end
    end
    resources :jobs, only: %i[index create]
    resources :paid_deposits, only: %i[index]
    namespace :paid_deposit do
      resources :deposit_statuses, only: %i[update]
    end
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
                     controllers: { confirmations: 'email_confirmations', sessions: 'auth/sessions', passwords: 'passwords' }

  resources :auctions, only: %i[index show], param: :uuid do
    resources :offers, only: %i[new show create edit update destroy], shallow: true, param: :uuid do
      get 'delete'
    end
    resources :english_offers, only: %i[new show create edit update], shallow: true, param: :uuid
    member do
      post 'pay_deposit', to: 'invoices#pay_deposit', as: 'english_offer_deposit'
    end
  end
  match '*auctions', controller: 'auctions', action: 'cors_preflight_check', via: [:options]

  resources :billing_profiles, param: :uuid
  match '/status', via: :get, to: 'health_checks#index'

  scope module: :invoices do
    resource :pay_all_cancelled_payable_invoices, only: :create
    resource :pay_all_issued_invoices, only: :create
  end

  resources :invoices, only: %i[show edit update index], param: :uuid do
    member do
      get 'download'
      post 'oneoff'
      post 'send_e_invoice', as: :send_e
    end

    collection do

      # TODO: Remove it. It is deprecated
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
  match '/linkpay_deposit_callback', via: %i[get], to: 'linkpay#deposit_callback', as: :deposit_callback

  resource :locale, only: :update
  resources :offers, only: :index
  resources :results, only: :show, param: :uuid

  resources :users, param: :uuid do
    resources :phone_confirmations, only: %i[new create] do
      scope module: :phone_confirmations do
        post :send_sms, to: 'send_sms#create', on: :collection
      end
    end
    scope module: :users do
      post :email_confirmation, to: 'email_confirmation#create', on: :collection
    end
  end

  resources :wishlist_items, param: :uuid, only: %i[index edit create destroy update]
  resources :autobider, param: :uuid, only: [:create, :update, :edit, :new]

  mount OkComputer::Engine, at: '/healthcheck', as: :healthcheck
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
