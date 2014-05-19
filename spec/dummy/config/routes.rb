Rails.application.routes.draw do
  root to: 'application#index'

  mount AssetManager::Engine => '/asset_manager'

  resources :posts
end
