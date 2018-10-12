require 'constraints/administrator'

Rails.application.routes.draw do
  root to: 'users#index'
  devise_for :users, path: 'sessions'

  concern :auditable do
    resources :versions, only: :index
  end

  namespace :admin, constraints: Constraints::Administrator.new do
    resources :billing_profiles, only: :index, concerns: [:auditable]
    resources :users, concerns: [:auditable]
    resources :settings, except: %i[create destroy], concerns: [:auditable]
  end

  resources :auctions, only: %i[index show]
  resources :billing_profiles
  resources :users, except: :destroy
end
