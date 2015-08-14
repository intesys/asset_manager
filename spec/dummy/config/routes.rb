Rails.application.routes.draw do
  resources :products


  root to: 'application#index'

  mount AssetManager::Engine => '/asset_manager'

  resources :posts
end
