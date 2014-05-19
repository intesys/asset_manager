require_dependency File.join(AssetManager::Engine.root, 'app', 'uploaders', 'asset_manager', 'asset_private_uploader.rb')

AssetManager::AssetPrivateUploader.class_eval do
  extend AssetManager::CustomVersions
  custom_versions
end
