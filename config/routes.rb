Rails.application.routes.draw do
  namespace :api do 
    namespace :v1 do 
      scope module: :merchants do
        get :MerchantsFind
        resources :merchants, only: [:index, :show] do 
          resources :items, only: [:index]
        end
      end
      # resources :customers, only: [:index]
      # resources :invoice_items, only: [:index]
      # resources :invoices, only: [:index]
      resources :items 
      # resources :transactions, only: [:index]
    end
  end
end
