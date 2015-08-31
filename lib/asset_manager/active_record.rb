class ActiveRecord::Base

  class << self
    attr_reader :am_file, :am_file_options, :am_files, :am_files_options

    def has_file(field, options = {})
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

    def has_private_file(field, options = {})
      has_file(field, options.merge(type: :private))
    end

    def has_image(field, options = {})
      has_file(field, options.merge(accepted: AssetManager.default_image_formats, mode: :image))
    end

    def has_files(field, options = {})
      options.assert_valid_keys(:accepted, :type, :mode, :max)
      options.reverse_merge!(type: :public, mode: :files, max: 999)

      @am_files = [] if @am_files.nil?
      @am_files.push(field) unless @am_files.include?(field)
      @am_files_options = {} if @am_files_options.nil?
      @am_files_options[field] = options

      attr_accessible am_field_name(field, true)

      has_many "asset_association_#{field}".to_sym, as: :owner, class_name: 'AssetManager::AssetAssociation', conditions: { context: "#{field}" }
      has_many "#{field}".to_sym, through: "asset_association_#{field}".to_sym, source: :asset, class_name: 'AssetManager::Asset'

      define_method "#{field.to_s.singularize}_ids=" do |ids|
        super(ids)
        ids.each_with_index do |value, index|
          aa = send("asset_association_#{field}").where(asset_id: value).first
          aa.update_attributes(position: (index+1))
        end
      end

      after_destroy :destroy_file_and_files_associations
    end

    def has_private_files(field, options = {})
      has_files(field, options.merge(type: :private))
    end

    def has_images(field, options = {})
      has_files(field, options.merge(accepted: AssetManager.default_image_formats, mode: :images))
    end

    def am_file_fields
      @am_file.nil? ? [] : @am_file
    end

    def am_files_fields
      @am_files.nil? ? [] : @am_files
    end

    def am_file_options
      @am_file_options.nil? ? {} : @am_file_options
    end

    def am_files_options
      @am_files_options.nil? ? {} : @am_files_options
    end

    def am_has_field?(field)
      am_file_fields.include?(field.to_sym) || am_files_fields.include?(field.to_sym)
    end

    def am_field_option(field, key)
      options = field_options(field)
      options[field.to_sym][key] rescue nil
    end

    def am_field_name(field, multiple)
      (multiple ? "#{field.to_s.singularize}_ids" : "#{field.to_s}_id").to_sym
    end

    private

    def field_options(field)
      am_file_fields.include?(field.to_sym) ? am_file_options : am_files_options
    end

  end

  private

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
