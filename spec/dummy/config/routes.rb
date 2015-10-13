Rails.application.routes.draw do

  mount AssetManager::Engine => '/asset_manager'

  resources :products

  resources :posts

  root 'application#index'
end
