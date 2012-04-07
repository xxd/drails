Dandan::Application.routes.draw do
  devise_for :users
  resources :lists, :only => [:index, :show, :create] do
    member do
      get :syncList
    end
  end
  resources :items
  resources :users
  resources :photos
  resources :voices
  resources :songs
  resources :categories, :only => [:index, :show] do
    member do
      get :syncCategory
    end
  end
  root :to => 'lists#index'
end
