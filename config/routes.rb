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
    resources :offers, only: [:show], concerns: [:auditable]
    resources :results, only: [:index, :create]
    resources :settings, except: %i[create destroy], concerns: [:auditable]
    resources :users, concerns: [:auditable]
  end

  resources :auctions, only: %i[index show] do
    resources :offers, only: %i[new show create edit update destroy], shallow: true
  end

  resources :billing_profiles
  resources :offers, only: :index
  resources :users, except: :destroy
end
