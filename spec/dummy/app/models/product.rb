class Product < ActiveRecord::Base
  attr_accessible :description, :title

  has_image :main_image
  has_images :pictures, max: 10
  has_files :downloads
end
