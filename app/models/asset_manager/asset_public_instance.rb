module AssetManager
  class AssetPublicInstance < AssetManager::AssetInstance
    belongs_to :asset, class_name: 'AssetManager::Asset', foreign_key: 'asset_id', inverse_of: :asset_public_instances
    mount_uploader :file, AssetPublicUploader
  end
end
