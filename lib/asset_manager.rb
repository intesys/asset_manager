require "asset_manager/engine"

require "sass-rails"

require "haml-rails"
require "mini_magick"
require "carrierwave"
require "jquery-ui-rails"
require "acts-as-taggable-on"
require "chosen-rails"
require "globalize3"
require "bootstrap-sass"
require "formtastic-bootstrap"
require "kaminari"
require "bootstrap_kaminari"
require "meta_search"

module AssetManager
  include ActiveSupport::Configurable
end

class ActiveRecord::Base

  class << self
    attr_reader :file, :file_options, :files, :files_options
  end

  def self.has_file(field, options = {})
    @file = [] if @file.nil?
    @file.push(field) unless @file.include?(field)

    options = self.set_default_type(options)
    options[:max] = 1
    @file_options = {} if @file_options.nil?
    @file_options[field] = options

    #set_default_association

    attr_accessible asset_field_name(field, false)
    attr_accessor asset_field_name(field, false)

    has_one "asset_association_#{field}".to_sym, :as => :owner,
      :class_name => 'AssetManager::AssetAssociation',
      :conditions => {:context => "#{field}"}
    has_one "#{field}".to_sym, :through => "asset_association_#{field}".to_sym,
      :source => :asset, :class_name => 'AssetManager::Asset'

    after_save :save_file_associations
  end

  def self.has_private_file(field, options = {})
    self.has_file(field, options.merge({type: :private}))
  end

  def self.has_files(field, options = {})
    @files = [] if @files.nil?
    @files.push(field) unless @files.include?(field)

    options = self.set_default_type(options)
    options[:max] = 999 unless options.include?(:max)
    @files_options = {} if @files_options.nil?
    @files_options[field] = options

    #set_default_association

    attr_accessible asset_field_name(field, true)
    attr_accessor asset_field_name(field, true)

    has_many "asset_association_#{field}".to_sym, :as => :owner,
      :class_name => 'AssetManager::AssetAssociation',
      :conditions => {:context => "#{field}"}
    has_many "#{field}".to_sym, :through => "asset_association_#{field}".to_sym,
      :source => :asset, :class_name => 'AssetManager::Asset'

    after_save :save_files_associations
  end

  def self.has_private_files(field, options = {})
    self.has_files(field, options.merge({type: :private}))
  end

  def self.file_fields
    @file.nil? ? [] : @file
  end

  def self.files_fields
    @files.nil? ? [] : @files
  end

  def self.file_options
    @file_options.nil? ? {} : @file_options
  end

  def self.files_options
    @files_options.nil? ? {} : @files_options
  end

  def self.has_field?(field)
    self.file_fields.include?(field.to_sym) || self.files_fields.include?(field.to_sym)
  end

  def self.get_option(field, key)
    options = self.get_options_by_field(field)
    options[field.to_sym][key] rescue nil
  end

  def self.asset_field_name(field, multiple)
    if multiple
      "#{field.to_s}_ids".to_sym
    else
      "#{field.to_s.singularize}_id".to_sym
    end
  end

  private

  def self.set_default_type(options)
    options[:type] = :public unless options.include?(:type)
    options
  end

  def self.get_options_by_field(field)
    self.file_fields.include?(field.to_sym) ? self.file_options : self.files_options
  end

  def save_file_associations
    self.class.file_fields.each do |field|
      value = send(self.class.asset_field_name(field, false))
      unless value.nil?
        ::AssetManager::AssetAssociation.destroy_all(
          owner_type: self.class.name,
          owner_id: id,
          context: field
        )
        unless value.blank?
          ::AssetManager::AssetAssociation.create(
            owner_type: self.class.name,
            owner_id: id,
            context: field,
            asset_id: value.to_i,
            position: 1
          )
        end
      end
    end
  end

  def save_files_associations
    self.class.files_fields.each do |field|
      values = send(self.class.asset_field_name(field, true))
      unless values.nil?
        ::AssetManager::AssetAssociation.destroy_all(
          owner_type: self.class.name,
          owner_id: id,
          context: field
        )
        values.reject!{ |a| a.strip.length == 0 }
        unless values.empty?
          values.each_with_index do |value, index|
            ::AssetManager::AssetAssociation.create(
              owner_type: self.class.name,
              owner_id: id,
              context: field,
              asset_id: value.to_i,
              position: (index + 1)
            )
          end
        end
      end
    end
  end


  #def self.set_default_association
  #  unless has_many_association?(:asset_associations)
  #    has_many :asset_associations, :as => :owner,
  #      :class_name => "AssetManager::AssetAssociation"
  #  end
  #end

  #def self.has_many_association?(name)
  #  associations = self.reflect_on_all_associations(:has_many)
  #  associations.any? { |a| a.name == name }
  #end
end

require "asset_manager/all"

