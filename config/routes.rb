Rails.application.routes.draw do
  root to: 'users#index'
  devise_for :users, path: 'sessions'

  resources :users, except: :destroy
end
