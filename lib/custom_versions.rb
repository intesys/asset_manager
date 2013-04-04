module AssetManager
  module CustomVersions

    # http://carrierwave.rubyforge.org/rdoc/classes/CarrierWave/RMagick.html
    def custom_versions
      version :thumb, :if => :image? do
        process :resize_and_pad => [50, 50]
      end
      version :list, :if => :image? do
        process :resize_and_pad => [100, 100]
      end
      version :page, :if => :image? do
        process :resize_and_pad => [200, 200]
      end
      version :show, :if => :image? do
        process :resize_and_pad => [300, 300]
      end
    end

  end
end
