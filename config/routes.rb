Rails.application.routes.draw do
  
  root "posts#index"
  resources :posts do
    member do
      post :tags
      delete :tag_d
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'signup', to: 'users#new'
  post "favorites", to: "favorites#create"
  delete "favorites", to: "favorites#destroy"
  resources :tags , only:[:show] do
    member do
      get :find
    end
  end
  resources :users, only:[:index, :show, :new, :create] do
    member do
      get :likes
      get :favorite_now
    end
  end
  
  resources :favorites, only: [:create, :destroy]#お気に入り登録/解除
  
end
