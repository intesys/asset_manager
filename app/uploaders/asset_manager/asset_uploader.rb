# encoding: utf-8

module AssetManager
  class AssetUploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick

    storage :file

    process :set_content_type

    def store_dir
      Rails.root.to_s + "/private/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    def cache_dir
      super
    end

    protected

    def image?(picture)
      %w(.jpg .png .jpeg .gif).include?(File.extname(picture.file).downcase)
    end

    def pdf?(picture)
      File.extname(picture.file).downcase == '.pdf'
    end

    private

    def end_path
      "#{mounted_as}/#{model.id % 1000}/#{model.id}"
    end
  end
end
