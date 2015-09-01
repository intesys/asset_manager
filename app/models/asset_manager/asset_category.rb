module AssetManager
  class AssetCategory < ActiveRecord::Base
    include Translations

    # before_save do
    #   translations.clone.each do |translation|
    #     translations.destroy(translation) if translation.title.blank?
    #   end
    # end

    # attr_accessible :title, :translations_attributes

    translates :title, fallbacks_for_empty_translations: true
    include TouchTranslation

    accepts_nested_attributes_for :translations

    validates :title, presence: true

    scope :sorted, -> { select("#{self.table_name}.*, #{self.translations_table_name}.title").with_translations.order(:title).distinct }
  end
end
