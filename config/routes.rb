Rails.application.routes.draw do
  # Model Routes
  resources :warehouses, only: [:create] do
    get 'distance_to_customer/:customer_id', to: 'warehouses#distance_to_customer'
  end
  resources :customers, only: [:create]

  # Non-Model 'CRUD' Routes
  post 'authenticate', to: 'authentication#create'
end
