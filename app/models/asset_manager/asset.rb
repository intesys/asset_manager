module AssetManager
  class Asset < ActiveRecord::Base
    include Translations

    before_validation do
      if file_type
        asset_instances.clone.each do |asset_instance|
          unless asset_instance.file.blank?
            if asset_instance.file.file.extension.downcase != file_type.downcase
              errors[:file_type] << "File type deve esserere [#{file_type}]"
            end
          end
        end
      else
        unless asset_instances.empty?
          first_type = asset_instances.first.file.file.extension
          unless asset_instances.select { |ai| ai.file.file.extension.downcase != first_type.downcase }.empty?
            errors[:file_type] << 'Devono avere tutti stessa estensione'
          end
        end
      end
    end

    before_save do
      unless asset_instances.empty?
        self.file_type = asset_instances.first.file.file.extension.downcase
      end
    end

    attr_accessible :title, :description, :asset_category_id, :public, :tag_list, :asset_public_instances_attributes,
                    :asset_private_instances_attributes, :translations_attributes, :file_type

    translates :title, :description, fallbacks_for_empty_translations: true
    include TouchTranslation

    acts_as_taggable_on :tags

    has_many :asset_associations, class_name: 'AssetManager::AssetAssociation', foreign_key: 'asset_id', dependent: :destroy
    has_many :asset_public_instances, class_name: 'AssetManager::AssetPublicInstance', foreign_key: 'asset_id', dependent: :destroy, inverse_of: :asset
    has_many :asset_private_instances, class_name: 'AssetManager::AssetPrivateInstance', foreign_key: 'asset_id', dependent: :destroy, inverse_of: :asset

    belongs_to :asset_category, class_name: 'AssetManager::AssetCategory'

    accepts_nested_attributes_for :translations, reject_if: lambda { |t| t[:title].blank? && t[:description].blank? }
    accepts_nested_attributes_for :asset_public_instances, reject_if: lambda { |t| t[:file].blank? }, allow_destroy: true
    accepts_nested_attributes_for :asset_private_instances, reject_if: lambda { |t| t[:file].blank? }, allow_destroy: true

    validates :title, presence: true

    scope :not_ids, lambda { |ids| { conditions: ['asset_manager_assets.id not in (?)', ids] } unless ids.empty? }
    scope :by_category_id, lambda { |id| where(asset_category_id: id) unless id.blank? }
    scope :by_instance_context, lambda { |ic| includes(:asset_instances).where("instance_context = #{ic}") unless ic.nil? }

    def self.public(public)
      case public
      when :public
        where(public: true)
      when :private
        where(public: false)
      else
        where('1=1')
      end
    end

    def self.accepted(file_type)
      if file_type
        file_type = [file_type] unless file_type.kind_of?(Array)
        where('file_type in (?)', file_type)
      else
        where('1=1')
      end
    end

    def self.find_ordered(ids)
      collection = Asset.find(ids)
      ids.map { |id| collection.find { |resource| resource.id == id.to_i } }
    end

    def alt
      description
    end

    def is_image?
      %w(jpg png jpeg gif).include?(file_type)
    end

    def is_pdf?
      file_type == 'pdf'
    end

    def has_this_instance_context?(ic)
      asset_instances.any? { |ai| ai.instance_context.to_sym == ic }
    end

    def asset_instances
      public ? asset_public_instances : asset_private_instances
    end
  end
end
