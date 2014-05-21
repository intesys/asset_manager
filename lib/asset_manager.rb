require 'asset_manager/engine'

require 'acts-as-taggable-on'
require 'bootstrap_kaminari'
require 'carrierwave'
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
require 'cocoon'

module AssetManager
  include ActiveSupport::Configurable

  # With Categories
  config.with_categories = true
  config_accessor :with_categories

  # With Tags
  config.with_tags = true
  config_accessor :with_tags

  # With Clippy
  config.with_clippy = false
  config_accessor :with_clippy

  # Asset types
  config.asset_types = :public
  config_accessor :asset_types, instance_reader: false

  def self.asset_types
    Array(config.asset_types)
  end

  def self.public_asset_type?
    asset_types.include?(:public)
  end

  def self.private_asset_type?
    asset_types.include?(:private)
  end

  def self.unique_asset_type?
    asset_types.length == 1
  end
end

require 'asset_manager/all'
