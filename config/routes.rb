Rails.application.routes.draw do

  root "posts#index"
  resources :posts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'signup', to: 'users#new'
  
  resources :users, only:[:index, :show, :new, :create] do
    member do
      get :likes
      get :favorite_now
    end
  end
  
  
end
