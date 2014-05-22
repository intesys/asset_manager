require 'asset_manager/engine'

require 'acts-as-taggable-on'
require 'bootstrap_kaminari'
require 'carrierwave'
require 'cocoon'
require 'fancybox2-rails'
require 'formtastic-bootstrap'
require 'globalize'
require 'haml-rails'
require 'jquery-fileupload-rails'
require 'jquery-ui-rails'
require 'kaminari'
require 'meta_search'
require 'mini_magick'
require 'sass-rails'

module AssetManager
  include ActiveSupport::Configurable

  ##
  # Asset types
  # Defines the visibility of your assets. You can specify:
  # [:public] or [:private] or [:private, :public]
  config.asset_types = :public
  config_accessor :asset_types, instance_reader: false

  ##
  # Default image formats
  # A list of file formats that will be accepted for has_image and has_images.
  config.default_image_formats = %w(jpg jpeg gif png)
  config_accessor :default_image_formats

  ##
  # With Categories
  # Decides whether or not your assets are organized by categories.
  config.with_categories = true
  config_accessor :with_categories

  ##
  # With Clippy
  # Permits you to copy an asset's URL to the clip board directly from the
  # assets list.
  config.with_clippy = false
  config_accessor :with_clippy

  ##
  # With Tags
  # Decides whether or not your assets are organized by tags.
  config.with_tags = true
  config_accessor :with_tags

  class << self
    def asset_types
      Array(config.asset_types)
    end

    def public_asset_type?
      asset_types.include?(:public)
    end

    def private_asset_type?
      asset_types.include?(:private)
    end

    def unique_asset_type?
      asset_types.length == 1
    end
  end
end

require 'asset_manager/all'
