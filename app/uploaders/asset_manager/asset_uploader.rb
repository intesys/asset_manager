# encoding: utf-8

module AssetManager
  class AssetUploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick
    include CarrierWave::MimeTypes

    storage :file

    def store_dir
      Rails.root.to_s + "/private/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    private

    def end_path
      "#{mounted_as}/#{model.id % 1000}/#{model.id}"
    end
  end
end
