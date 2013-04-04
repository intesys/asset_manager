module AssetManager
  class AssetPublicInstance < AssetManager::AssetInstance
    mount_uploader :file, AssetPublicUploader
  end
end

