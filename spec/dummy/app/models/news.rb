class News < ActiveRecord::Base
  attr_accessible :date, :description, :title

  validate :title, :presence => true
  validate :date, :presence => true

  has_file :image
  has_files :files
end
