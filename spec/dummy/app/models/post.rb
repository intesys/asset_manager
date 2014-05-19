class Post < ActiveRecord::Base
  attr_accessible :title, :sub_title

  has_many :comments

  validate :title, presence: true
  validate :sub_title, presence: true

  has_image :main_image
  has_images :pictures
  has_file :main_card
  has_files :downloads
end
