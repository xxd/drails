Dandan::Application.routes.draw do
  devise_for :users
  resources :lists, :only => [:index, :show, :create] do
    member do
      get :sync
    end
  end
  resources :items, :only => [:index, :show, :create] do
    member do
      get :sync
    end
  end
  resources :users
  resources :photos
  resources :voices
  resources :songs
  resources :categories, :only => [:index, :show] do
    member do
      get :sync
    end
  end
  root :to => 'lists#index'
end
