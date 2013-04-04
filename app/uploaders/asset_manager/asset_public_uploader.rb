# encoding: utf-8

module AssetManager
  class AssetPublicUploader < AssetManager::AssetUploader
    extend AssetManager::CustomVersions
    custom_versions

    def store_dir
      Rails.root.to_s + "/public/uploads/" + end_path
    end

    protected

    def image?(picture)
      ['.jpg', '.png', '.jpeg', '.gif'].include?(File.extname(picture.file).downcase)
    end
  end
end
