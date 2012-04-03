Dandan::Application.routes.draw do
  devise_for :users
  resources :lists
  resources :items
  resources :users
  resources :photos
  resources :voices
  resources :songs
  root :to => 'lists#index'
end
