class Post < ActiveRecord::Base
  attr_accessible :title, :sub_title

  has_many :comments

  validate :title, presence: true

  has_image :main_image
  has_images :images
  has_file :main_file
  has_files :files
  has_file :not_singulars
  has_files :not_plural
end
