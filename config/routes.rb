AssetManager::Engine.routes.draw do
  resources :assets do
    collection do
      get 'preview'
      get 'select'
      get 'multiple_select'
    end
  end
  resources :asset_categories

  get "index/index"
  root :to => "index#index"
end
