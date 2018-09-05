Rails.application.routes.draw do
  devise_for :users, path: 'sessions'

  resources :users, except: :destroy
  root to: 'users#new'
end
