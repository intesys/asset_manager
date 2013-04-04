module AssetManager
  class AssetPrivateInstance < AssetManager::AssetInstance
    mount_uploader :file, AssetPrivateUploader
  end
end
