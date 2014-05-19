AssetManager::Engine.routes.draw do
  resources :assets, path: 'managed_assets' do
    collection do
      get 'preview'
      get 'select'
      get 'multiple_select'
      post 'quick_upload'
    end
    member do
      get 'show/:context', to: 'asset_instances#show', as: :render
      get 'admin_show/:context', to: 'asset_instances#admin_show', as: :admin_render
      get 'download/:context', to: 'asset_instances#show', as: :download, download: true
      get 'admin_download/:context', to: 'asset_instances#admin_show', as: :admin_download, download: true
    end
  end
  resources :asset_categories

  get 'index/index'
  root to: 'assets#index'
end
