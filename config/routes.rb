require 'constraints/administrator'

Rails.application.routes.draw do
  root to: 'users#index'
  devise_for :users, path: 'sessions'

  namespace :admin, constraints: Constraints::Administrator.new do
    resources :users
    resources :billing_profiles
  end

  resources :users, except: :destroy
  resources :billing_profiles
end
