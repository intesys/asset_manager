# encoding: utf-8

module AssetManager
  class AssetPrivateUploader < AssetManager::AssetUploader
    def store_dir
      Rails.root.to_s + "/private/uploads/" + end_path
    end
  end
end
