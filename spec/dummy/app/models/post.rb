class Post < ActiveRecord::Base
  attr_accessible :title, :sub_title

  validate :title, :presence => true
  validate :sub_title, :presence => true

  has_file  :photo, { accepted: %w(png gif) }
  has_files :images
  has_private_files :downloads
end

