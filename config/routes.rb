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
  end

  resources :users, except: :destroy
  resources :billing_profiles
end
