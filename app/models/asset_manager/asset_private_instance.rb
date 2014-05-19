module AssetManager
  class AssetPrivateInstance < AssetManager::AssetInstance
    belongs_to :asset, class_name: 'AssetManager::Asset', foreign_key: 'asset_id', inverse_of: :asset_private_instances
    mount_uploader :file, AssetPrivateUploader
  end
end
