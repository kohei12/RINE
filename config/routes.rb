Rails.application.routes.draw do
  get 'rooms/index'

  get 'rooms/show'

  get 'messages/index'

  get "log_out" => 'sessions#destroy', as: "log_out"
  get "log_in" => 'sessions#new', as: "log_in"
  get "sign_up" => 'users#new', as: "sign_up"

  root to: "users#new"

  resources :users

  resources :sessions

  resources :friendships
  
  resources :messages

  resources :rooms
end
