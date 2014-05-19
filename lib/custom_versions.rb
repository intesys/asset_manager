module AssetManager
  module CustomVersions
    # http://carrierwave.rubyforge.org/rdoc/classes/CarrierWave/RMagick.html
    def custom_versions
      version :thumb, if: :image? do
        process resize_and_pad: [50, 50]
      end
      version :show, if: :image? do
        process resize_and_pad: [300, 300]
      end
      version :thumb_pdf, if: :pdf? do
        process convert: :jpg
        process resize_to_fill: [230, 326]
        def full_filename(for_file = model.source.file)
          super.chomp(File.extname(super)) + '.jpg'
        end
      end
    end
  end
end
