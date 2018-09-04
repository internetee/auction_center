Rails.application.routes.draw do
  devise_for :users, path: 'sessions'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, except: :destroy
end
