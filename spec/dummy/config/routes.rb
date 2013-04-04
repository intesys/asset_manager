Rails.application.routes.draw do
  root :to => "application#index"

  get "welcome/index"

  mount AssetManager::Engine => "/asset_manager"

  resources :posts
  #resources :news

  #ActiveAdmin.routes(self)

end
