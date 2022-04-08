Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :items do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/:id/merchant', to: 'merchants#index'
      end
      namespace :merchants do
        get '/find_all', to: 'search#index'
        get '/find', to: 'search#show'
        get '/most_items', to: 'search#most_items'
      end
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], module: :merchants
      end
      resources :items do
        resources :merchant, only: [:index]
      end
      namespace :revenue do 
        resources :merchants, only: [:index]
        resources :items, only: [:index]
      end
      resources :invoices
      get '/revenue', to: 'revenue/merchants#total_revenue'
      resources :sessions, only: [:create]
      resources :registrations, only: [:create]
      delete :logout, to: "sessions#logout" 
      get :logged_in, to: "sessions#logged_in"
    end
  end
end