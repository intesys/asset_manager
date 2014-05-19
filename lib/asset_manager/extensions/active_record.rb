class ActiveRecord::Base
  class << self
    attr_reader :am_file, :am_file_options, :am_files, :am_files_options
  end

  def self.has_file(field, options = {})
    fail "has_file :#{field} for #{name} class is not a valid name. The name must be singular!" if field.to_s != field.to_s.singularize
    options.assert_valid_keys(:accepted, :type, :mode)
    options.reverse_merge!(type: :public, max: 1, mode: :file)

    @am_file = [] if @am_file.nil?
    @am_file.push(field) unless @am_file.include?(field)
    @am_file_options = {} if @am_file_options.nil?
    @am_file_options[field] = options

    attr_accessible am_field_name(field, false)
    attr_accessor am_field_name(field, false)

    has_one "asset_association_#{field}".to_sym, as: :owner, class_name: 'AssetManager::AssetAssociation', conditions: { context: "#{field}" }
    has_one "#{field}".to_sym, through: "asset_association_#{field}".to_sym, source: :asset, class_name: 'AssetManager::Asset'

    after_save :save_file_associations
    after_destroy :destroy_file_and_files_associations
  end

  def self.has_private_file(field, options = {})
    has_file(field, options.merge(type: :private))
  end

  def self.has_image(field, options = {})
    has_file(field, options.merge(accepted: %w(jpg gif png), mode: :image))
  end

  def self.has_files(field, options = {})
    fail "has_files :#{field} for #{name} class is not a valid name. The name must be plural!" if field.to_s != field.to_s.pluralize
    options.assert_valid_keys(:accepted, :type, :mode, :max)
    options.reverse_merge!(type: :public, mode: :files, max: 999)

    @am_files = [] if @am_files.nil?
    @am_files.push(field) unless @am_files.include?(field)
    @am_files_options = {} if @am_files_options.nil?
    @am_files_options[field] = options

    attr_accessible am_field_name(field, true)

    has_many "asset_association_#{field}".to_sym, as: :owner, class_name: 'AssetManager::AssetAssociation', conditions: { context: "#{field}" }
    has_many "#{field}".to_sym, through: "asset_association_#{field}".to_sym, source: :asset, class_name: 'AssetManager::Asset'

    after_save :save_files_associations
    after_destroy :destroy_file_and_files_associations
  end

  def self.has_private_files(field, options = {})
    has_files(field, options.merge(type: :private))
  end

  def self.has_images(field, options = {})
    has_files(field, options.merge(accepted: %w(jpg gif png), mode: :images))
  end

  def self.am_file_fields
    @am_file.nil? ? [] : @am_file
  end

  def self.am_files_fields
    @am_files.nil? ? [] : @am_files
  end

  def self.am_file_options
    @am_file_options.nil? ? {} : @am_file_options
  end

  def self.am_files_options
    @am_files_options.nil? ? {} : @am_files_options
  end

  def self.am_has_field?(field)
    am_file_fields.include?(field.to_sym) || am_files_fields.include?(field.to_sym)
  end

  def self.am_field_option(field, key)
    options = field_options(field)
    options[field.to_sym][key] rescue nil
  end

  def self.am_field_name(field, multiple)
    "#{field.to_s.singularize}_#{multiple ? 'ids' : 'id'}".to_sym
  end

  private

  def self.field_options(field)
    am_file_fields.include?(field.to_sym) ? am_file_options : am_files_options
  end

  def save_file_associations
    self.class.am_file_fields.each do |field|
      value = send(self.class.am_field_name(field, false))
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
    self.class.am_files_fields.each do |field|
      values = send(self.class.am_field_name(field, true))
      unless values.nil?
        ::AssetManager::AssetAssociation.destroy_all(
            owner_type: self.class.name,
            owner_id: id,
            context: field
        )
        values.reject! { |a| a.to_s.strip.length == 0 }
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

  def destroy_file_and_files_associations
    (self.class.am_file_fields + self.class.am_files_fields).each do |field|
      ::AssetManager::AssetAssociation.destroy_all(
          owner_type: self.class.name,
          owner_id: id,
          context: field
      )
    end
  end
end
