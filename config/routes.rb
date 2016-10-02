Rails.application.routes.draw do
  resources :orders
  resources :line_items
  resources :carts,   only: [:show, :destroy]
  resources :products
  root 'store#index', as: 'store_index'
end
